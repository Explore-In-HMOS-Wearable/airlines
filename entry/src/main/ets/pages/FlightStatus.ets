import { FlightCard } from '../components/FlightCard';
import { Flight, } from '../mock/Types';
import { getFlights } from '../mock/MockData';
import { Theme } from '../theme/Theme';

@Builder
export function FlightStatusPageBuilder() {
  FlightStatus();
}

@Component
struct FlightStatus {
  private flights: Flight[] = [];
  @Consume('pageStack') pageStack: NavPathStack;

  aboutToAppear() {
    this.flights = getFlights();
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.flight_status'))
          .fontSize(Theme.FontSize.large)
          .fontColor(Theme.Colors.textSecondary())
          .margin({ top: Theme.Margin.medium, bottom: Theme.Margin.xs });

        if (this.flights && this.flights.length > 0) {
          Scroll() {
            Column({ space: Theme.Margin.small }) {
              ForEach(this.flights, (flight: Flight) => {
                FlightCard({
                  flight: flight,
                  onCardClick: () => {
                    this.pageStack.pushPathByName('FlightDetail', flight.id);
                  }
                });
              }, (flight: Flight) => flight.id.toString());
            }
            .width('100%')
            .padding({
              left: Theme.Padding.medium,
              right: Theme.Padding.medium,
              top: Theme.Padding.medium,
              bottom: Theme.Padding.large
            });
          }
          .layoutWeight(1)
          .align(Alignment.Top);
        } else {
          Column({ space: Theme.Margin.large }) {
            Text($r('app.string.no_flights_found'))
              .fontSize(Theme.FontSize.large)
              .fontColor(Theme.Colors.textPrimary())
              .fontWeight(Theme.Weight.medium);

            Text($r('app.string.sync_trips'))
              .fontSize(Theme.FontSize.small)
              .fontColor(Theme.Colors.textSecondary())
              .textAlign(TextAlign.Center)
              .width('80%');
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center);
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Theme.Colors.background());
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    });

  }
}