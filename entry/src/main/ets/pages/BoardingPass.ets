import { Flight, FlightTicket } from '../mock/Types';
import { getFlight, getFlightTicket } from '../mock/MockData';
import { Theme } from '../theme/Theme';
import { DateHelper } from '../utils/DateHelper';

@Builder
export function BoardingPassPageBuilder(name: string, param: Object) {
  BoardingPassPage({ param: param as number });
}

@Component
export struct BoardingPassPage {
  @State flight: Flight | null = null;
  @State ticket: FlightTicket | undefined = undefined;
  @Consume('pageStack') pageStack: NavPathStack;
  param: number = 0;

  aboutToAppear() {
    if (this.param) {
      this.flight = getFlight(this.param);
      this.ticket = getFlightTicket(this.param) ?? undefined;
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.boarding_pass'))
          .fontSize(Theme.FontSize.large)
          .fontColor(Theme.Colors.textSecondary())
          .margin({ top: Theme.Margin.large, bottom: Theme.Margin.small });

        if (this.flight && this.ticket?.qrCode) {
          Scroll() {
            Column({ space: Theme.Margin.medium }) {
              Column({ space: Theme.Margin.xs }) {
                Text(this.flight.flightNumber)
                  .fontSize(Theme.FontSize.xlarge)
                  .fontColor(Theme.Colors.textPrimary())
                  .fontWeight(Theme.Weight.bold);

                Row({ space: 4 }) {
                  Text(this.flight.origin)
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.textSecondary());
                  Text('→')
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.textDisabled());
                  Text(this.flight.destination)
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.textSecondary());
                };
              }
              .width('100%');

              Column({ space: Theme.Margin.small }) {
                Row() {
                  Text($r('app.string.seat'))
                    .fontSize(Theme.FontSize.small)
                    .fontColor(Theme.Colors.textSecondary())
                    .width('35%');
                  Text(this.ticket.seat ?? '--')
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.textPrimary())
                    .fontWeight(Theme.Weight.bold)
                    .textAlign(TextAlign.End)
                    .layoutWeight(1);
                }
                .width('70%');

                Row() {
                  Text($r('app.string.gate'))
                    .fontSize(Theme.FontSize.small)
                    .fontColor(Theme.Colors.textSecondary())
                    .width('35%');
                  Text(this.ticket.gate ?? '--')
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.textPrimary())
                    .fontWeight(Theme.Weight.bold)
                    .textAlign(TextAlign.End)
                    .layoutWeight(1);
                }
                .width('70%');

                Row() {
                  Text($r('app.string.boarding'))
                    .fontSize(Theme.FontSize.small)
                    .fontColor(Theme.Colors.textSecondary())
                    .width('35%');
                  Text(DateHelper.getBoardingTime(this.flight.departureDate))
                    .fontSize(Theme.FontSize.medium)
                    .fontColor(Theme.Colors.warning())
                    .fontWeight(Theme.Weight.medium)
                    .textAlign(TextAlign.End)
                    .layoutWeight(1);
                }
                .width('70%');
              }
              .margin({ bottom: Theme.Margin.xs });

              Text($r('app.string.down')).rotate({ angle: 90 });

              QRCode(this.ticket?.qrCode)
                .width(150)
                .height(150)
                .color(Theme.Colors.textInverse())
                .backgroundColor(Theme.Colors.textPrimary())
                .borderRadius(Theme.Radius.medium)
                .margin({ top: 5, bottom: Theme.Margin.xlarge });
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .padding({ top: Theme.Padding.small });
          }
          .layoutWeight(1)
          .align(Alignment.Top);
        } else {
          Column({ space: Theme.Margin.large }) {
            Text($r('app.string.no_boarding_pass'))
              .fontSize(Theme.FontSize.large)
              .fontColor(Theme.Colors.textPrimary())
              .fontWeight(Theme.Weight.medium);

            Text($r('app.string.check_in_required'))
              .fontSize(Theme.FontSize.small)
              .fontColor(Theme.Colors.textSecondary())
              .textAlign(TextAlign.Center)
              .width('75%');
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center);
        }
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