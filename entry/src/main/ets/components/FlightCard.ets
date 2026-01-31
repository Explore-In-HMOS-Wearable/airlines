import { Flight } from '../mock/Types';
import { Theme } from '../theme/Theme';
import { DateHelper } from '../utils/DateHelper';

@Component
export struct FlightCard {
  @Prop flight: Flight;
  onCardClick: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Text(this.flight.flightNumber)
          .fontSize(Theme.FontSize.medium)
          .fontColor(Theme.Colors.textPrimary())
          .fontWeight(Theme.Weight.medium);
        Blank();
        Text(DateHelper.formatDate(this.flight.departureDate))
          .fontSize(Theme.FontSize.small)
          .fontColor(Theme.Colors.textSecondary());
      }
      .width('100%')
      .margin({ bottom: Theme.Margin.xs });

      Row({ space: Theme.Margin.medium }) {
        Text(this.flight.origin)
          .fontSize(Theme.FontSize.xxlarge)
          .fontColor(Theme.Colors.textPrimary())
          .fontWeight(Theme.Weight.bold);

        Text('→')
          .fontSize(Theme.FontSize.large)
          .fontColor(Theme.Colors.textDisabled());

        Text(this.flight.destination)
          .fontSize(Theme.FontSize.xxlarge)
          .fontColor(Theme.Colors.textPrimary())
          .fontWeight(Theme.Weight.bold);

        Blank();

        Text('›')
          .fontSize(28)
          .fontColor(Theme.Colors.textDisabled());
      }
      .width('100%');
    }
    .width('100%')
    .padding({
      left: Theme.Padding.medium,
      right: Theme.Padding.medium,
      top: Theme.Padding.small,
      bottom: Theme.Padding.small
    })
    .backgroundColor(Theme.Colors.surface())
    .borderRadius(Theme.Radius.large)
    .onClick(() => {
      this.onCardClick();
    });
  }
}