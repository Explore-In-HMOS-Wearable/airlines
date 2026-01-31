import { wearEngine } from '@kit.WearEngine';
import { fileIo as fs } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Flight, FlightTicket } from '../mock/Types';

const TAG = 'WearEngine';
const DOMAIN = 0x0000;

export interface FlightDataPayload {
  flights: Flight[];
  tickets: FlightTicket[];
  syncTime: string;
}

export class WatchWearEngineService {
  private mobileBundleName: string = '';
  private mobileFingerprint: string = '';
  private context: Context;
  private deviceClient: wearEngine.DeviceClient;
  private p2pClient: wearEngine.P2pClient;
  private targetDevice: wearEngine.Device | undefined;
  private textEncoder = new util.TextEncoder();
  private textDecoder = new util.TextDecoder();
  private fileReceiverCallback: ((file: wearEngine.P2pFile) => void) | null = null;

  constructor(context: Context) {
    this.context = context;
    this.deviceClient = wearEngine.getDeviceClient(context);
    this.p2pClient = wearEngine.getP2pClient(context);
  }

  async initialize(onDataReceived: (data: FlightDataPayload) => void): Promise<boolean> {
    try {
      const device = await this.getConnectedPhoneDevice();
      if (!device) {
        hilog.error(DOMAIN, TAG, 'No phone device found');
        return false;
      }

      const isInstalled = await this.isMobileAppInstalled();
      if (!isInstalled) {
        hilog.warn(DOMAIN, TAG, 'Mobile app not installed');
      }

      await this.registerFileReceiver(onDataReceived);

      hilog.info(DOMAIN, TAG, 'WearEngine initialized successfully');
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Initialize error: ${error.code}, ${error.message}`);
      return false;
    }
  }

  private async getConnectedPhoneDevice(): Promise<wearEngine.Device | undefined> {
    try {
      const devices = await this.deviceClient.getConnectedDevices();
      hilog.info(DOMAIN, TAG, `Connected devices: ${devices.length}`);

      this.targetDevice = devices[0];

      if (this.targetDevice) {
        hilog.info(DOMAIN, TAG, `Found device: ${this.targetDevice.name}`);
      }

      return this.targetDevice;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `getConnectedDevices error: ${error.code}, ${error.message}`);
      return undefined;
    }
  }

  private async isMobileAppInstalled(): Promise<boolean> {
    if (!this.targetDevice) {
      return false;
    }

    try {
      const isInstalled = await this.p2pClient.isRemoteAppInstalled(
        this.targetDevice.randomId,
        this.mobileBundleName
      );
      hilog.info(DOMAIN, TAG, `Mobile app installed: ${isInstalled}`);
      return isInstalled;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `isRemoteAppInstalled error: ${error.code}, ${error.message}`);
      return false;
    }
  }

  private async registerFileReceiver(onDataReceived: (data: FlightDataPayload) => void): Promise<void> {
    if (!this.targetDevice) {
      return;
    }

    try {
      const appInfo: wearEngine.AppInfo = {
        bundleName: this.mobileBundleName,
        fingerprint: this.mobileFingerprint
      };

      const appParam: wearEngine.P2pAppParam = {
        remoteApp: appInfo
      };

      this.fileReceiverCallback = async (p2pFile: wearEngine.P2pFile) => {
        hilog.info(DOMAIN, TAG, `File received: ${p2pFile.file.name}, path: ${p2pFile.file.path}`);

        try {
          const content = await this.readFileContent(p2pFile.file.path);
          if (!content) {
            hilog.error(DOMAIN, TAG, 'Failed to read file content');
            return;
          }

          const flightData: FlightDataPayload = JSON.parse(content);
          hilog.info(DOMAIN, TAG, `Parsed ${flightData.flights.length} flights, ${flightData.tickets.length} tickets`);

          onDataReceived(flightData);

          await this.saveFlightDataToLocal(flightData);
        } catch (error) {
          hilog.error(DOMAIN, TAG, `File processing error: ${error}`);
        }
      };

      await this.p2pClient.registerFileReceiver(
        this.targetDevice.randomId,
        appParam,
        this.fileReceiverCallback
      );

      hilog.info(DOMAIN, TAG, 'File receiver registered');
    } catch (error) {
      hilog.error(DOMAIN, TAG, `registerFileReceiver error: ${error.code}, ${error.message}`);
    }
  }

  private async readFileContent(filePath: string): Promise<string | null> {
    try {
      const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(filePath);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);
      const decoder = new util.TextDecoder();
      return decoder.decodeToString(new Uint8Array(buffer));
    } catch (error) {
      hilog.error(DOMAIN, TAG, `readFileContent error: ${error}`);
      return null;
    } finally {
      fs.closeSync(file);
    }
  }

  private async saveFlightDataToLocal(data: FlightDataPayload): Promise<void> {
    try {
      const localPath = `${this.context.filesDir}/flight_data_local.json`;
      const jsonData = JSON.stringify(data);
      const file = fs.openSync(localPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      fs.writeSync(file.fd, jsonData);
      hilog.info(DOMAIN, TAG, `Flight data saved to: ${localPath}`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `saveFlightDataToLocal error: ${error}`);
    } finally {
      fs.closeSync(file);
    }
  }

  async loadFlightDataFromLocal(): Promise<FlightDataPayload | null> {
    try {
      const localPath = `${this.context.filesDir}/flight_data_local.json`;

      if (!fs.accessSync(localPath)) {
        hilog.info(DOMAIN, TAG, 'No local data file found');
        return null;
      }

      const content = await this.readFileContent(localPath);
      if (!content) {
        return null;
      }

      const data: FlightDataPayload = JSON.parse(content);
      hilog.info(DOMAIN, TAG, `Loaded ${data.flights.length} flights from local storage`);
      return data;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `loadFlightDataFromLocal error: ${error}`);
      return null;
    }
  }

  async sendMessageToPhone(message: string): Promise<boolean> {
    if (!this.targetDevice) {
      return false;
    }

    try {
      const appInfo: wearEngine.AppInfo = {
        bundleName: this.mobileBundleName,
        fingerprint: this.mobileFingerprint
      };

      const appParam: wearEngine.P2pAppParam = {
        remoteApp: appInfo
      };

      const p2pMessage: wearEngine.P2pMessage = {
        content: this.textEncoder.encodeInto(message)
      };

      const result = await this.p2pClient.sendMessage(
        this.targetDevice.randomId,
        appParam,
        p2pMessage
      );

      hilog.info(DOMAIN, TAG, `sendMessage result: ${result.code}`);
      return result.code === wearEngine.P2pResultCode.COMMUNICATION_SUCCESS;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `sendMessage error: ${error.code}, ${error.message}`);
      return false;
    }
  }

  async unregisterReceivers(): Promise<void> {
    if (!this.targetDevice || !this.fileReceiverCallback) {
      return;
    }

    try {
      const appInfo: wearEngine.AppInfo = {
        bundleName: this.mobileBundleName,
        fingerprint: this.mobileFingerprint
      };

      const appParam: wearEngine.P2pAppParam = {
        remoteApp: appInfo
      };

      await this.p2pClient.unregisterFileReceiver(
        this.targetDevice.randomId,
        appParam,
        this.fileReceiverCallback
      );

      hilog.info(DOMAIN, TAG, 'File receiver unregistered');
    } catch (error) {
      hilog.error(DOMAIN, TAG, `unregisterReceivers error: ${error}`);
    }
  }
}