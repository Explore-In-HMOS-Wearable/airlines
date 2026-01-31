import { Flight, FlightTicket } from '../mock/Types';
import { getFlight, getFlightTicket } from '../mock/MockData';
import { StatusChip } from '../components/StatusChip';
import { Theme } from '../theme/Theme';
import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ArcButtonPosition,
  LengthMetrics,
  LengthUnit
} from '@kit.ArkUI';
import { DateHelper } from '../utils/DateHelper';

@Builder
export function FlightDetailPageBuilder(name: string, param: Object) {
  FlightDetail({ param: param as number });
}

@Component
struct FlightDetail {
  private flight: Flight | null = null;
  private ticket: FlightTicket | undefined = undefined;
  private arcButtonOptions: ArcButtonOptions = new ArcButtonOptions({});
  @Consume('pageStack') pageStack: NavPathStack;
  param: number = 0;

  aboutToAppear() {
    if (this.param) {
      this.flight = getFlight(this.param);
      this.ticket = getFlightTicket(this.param);
    }

    this.arcButtonOptions = new ArcButtonOptions({
      label: $r('app.string.view_boarding_pass'),
      status: ArcButtonStatus.NORMAL,
      position: ArcButtonPosition.BOTTOM_EDGE,
      styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
      fontSize: new LengthMetrics(16, LengthUnit.FP),
      shadowEnabled: true,
      onClick: () => {
        if (this.flight) {
          this.pageStack.pushPathByName('BoardingPassPage', this.flight.id);
        }
      }
    });
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Text($r('app.string.flight_status'))
            .fontSize(Theme.FontSize.large)
            .fontColor(Theme.Colors.textSecondary())
            .margin({ top: Theme.Margin.large, bottom: Theme.Margin.medium });

          if (this.flight) {
            Scroll() {
              Column({ space: 0 }) {
                Row() {
                  Column({ space: 4 }) {
                    Text(DateHelper.formatDate(this.flight.departureDate))
                      .fontSize(Theme.FontSize.medium)
                      .fontColor(Theme.Colors.textPrimary());

                    Text(DateHelper.getDayName(this.flight.departureDate))
                      .fontSize(Theme.FontSize.small)
                      .fontColor(Theme.Colors.textSecondary());
                  }
                  .alignItems(HorizontalAlign.Start);

                  Blank();

                  Column({ space: 4 }) {
                    Text(this.flight.flightNumber)
                      .fontSize(Theme.FontSize.medium)
                      .fontColor(Theme.Colors.textPrimary())
                      .fontWeight(Theme.Weight.medium);

                    StatusChip({ status: this.flight.status });
                  }
                  .alignItems(HorizontalAlign.End);
                }
                .width('100%')
                .padding({ left: Theme.Padding.large, right: Theme.Padding.large, top: Theme.Padding.small });

                Divider()
                  .width('90%')
                  .color(Theme.Colors.divider())
                  .strokeWidth(1)
                  .margin({ top: Theme.Margin.medium, bottom: Theme.Margin.xs });

                Row() {
                  Column({ space: 8 }) {
                    Text(this.flight.origin)
                      .fontSize(20)
                      .fontColor(Theme.Colors.textPrimary())
                      .fontWeight(Theme.Weight.bold);

                    Text(DateHelper.formatTime(this.flight.departureDate))
                      .fontSize(Theme.FontSize.small)
                      .fontColor(Theme.Colors.textPrimary());

                    Text(DateHelper.formatTime(this.flight.departureDate))
                      .fontSize(Theme.FontSize.small)
                      .fontColor(Theme.Colors.success());
                  }
                  .alignItems(HorizontalAlign.Start);

                  Column({ space: 6 }) {
                    Text('→')
                      .fontSize(24)
                      .fontColor(Theme.Colors.textDisabled());

                    Text($r('app.string.gate'))
                      .fontSize(Theme.FontSize.xs)
                      .fontColor(Theme.Colors.textSecondary());

                    Text(this.ticket?.gate ?? '--')
                      .fontSize(Theme.FontSize.large)
                      .fontColor(Theme.Colors.textPrimary())
                      .fontWeight(Theme.Weight.medium);
                  }
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center);

                  Column({ space: 8 }) {
                    Text(this.flight.destination)
                      .fontSize(20)
                      .fontColor(Theme.Colors.textPrimary())
                      .fontWeight(Theme.Weight.bold);

                    Text(DateHelper.formatTime(this.flight.arrivalDate))
                      .fontSize(Theme.FontSize.small)
                      .fontColor(Theme.Colors.textPrimary());

                    Text(DateHelper.formatTime(this.flight.arrivalDate))
                      .fontSize(Theme.FontSize.small)
                      .fontColor(Theme.Colors.success());
                  }
                  .alignItems(HorizontalAlign.End);
                }
                .width('100%')
                .padding({ left: Theme.Padding.large, right: Theme.Padding.large })
                .justifyContent(FlexAlign.SpaceBetween);
              }
              .width('100%');
            }
            .layoutWeight(1)
            .align(Alignment.Top);

            ArcButton({ options: this.arcButtonOptions });
          } else {
            Column() {
              Text($r('app.string.flight_not_found'))
                .fontSize(Theme.FontSize.medium)
                .fontColor(Theme.Colors.textSecondary());
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center);
          }
        }
        .width('100%')
        .height('100%');
      }
      .width('100%')
      .height('100%')

      .backgroundColor(Theme.Colors.background());
    }.onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
    .hideTitleBar(true);
  }
}