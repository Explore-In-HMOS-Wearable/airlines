import { Theme } from '../theme/Theme';
import { BoardingPassPageBuilder } from './BoardingPass';
import { FlightDetailPageBuilder } from './FlightDetail';
import { FlightStatusPageBuilder } from './FlightStatus';

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  pageMap(name: string, param: Object) {
    if (name === 'FlightStatus') {
      FlightStatusPageBuilder();
    } else if (name === 'FlightDetail') {
      FlightDetailPageBuilder(name, param);
    } else if (name === 'BoardingPassPage') {
      BoardingPassPageBuilder(name, param);
    }
  }

  build() {
    Navigation(this.pageStack) {
      Stack() {
        Image($r('app.media.fl_status'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .brightness(0.6);

        Column() {
          Image($r('app.media.fl_status'))
            .width(24)
            .height(24)
            .borderRadius(10000)
            .margin({ bottom: Theme.Margin.small })
            .fillColor(Theme.Colors.secondary());

          Text($r('app.string.index_subtitle'))
            .fontSize(Theme.FontSize.small)
            .fontColor(Theme.Colors.textPrimary())
            .opacity(0.8)
            .fontWeight(Theme.Weight.medium);

          Text($r('app.string.index_title'))
            .fontSize(Theme.FontSize.xxlarge)
            .fontColor(Theme.Colors.textPrimary())
            .fontWeight(Theme.Weight.bold)
            .margin({ top: Theme.Margin.xs, bottom: Theme.Margin.large });

          Button() {
            Row() {
              Text($r('app.string.index_button'))
                .fontSize(Theme.FontSize.medium)
                .fontColor(Theme.Colors.textInverse())
                .fontWeight(Theme.Weight.bold);

              SymbolGlyph($r('sys.symbol.chevron_right'))
                .fontSize(Theme.FontSize.xlarge)
                .margin({ left: Theme.Margin.small });
            }
            .padding({
              left: Theme.Padding.large,
              right: Theme.Padding.medium,
              top: Theme.Padding.xs,
              bottom: Theme.Padding.xs
            });
          }
          .backgroundColor(Theme.Colors.onSecondary())
          .borderRadius(Theme.Radius.small)
          .shadow({
            radius: 20,
            color: '#40000000',
            offsetY: 10
          })
          .onClick(() => {
            this.pageStack.pushPathByName('FlightStatus', null);
          });
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .padding(Theme.Padding.xlarge);
      }
      .width('100%')
      .height('100%');
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.pageMap);
  }
}