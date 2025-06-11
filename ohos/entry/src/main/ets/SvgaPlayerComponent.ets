import { SvgaPlayerView } from "./SvgaPlayerView";
import { SvgaPlayerV2, SvgaController } from '@tb-open/svga';
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
@Component
export struct SvgaPlayerComponent {
  private controller: SvgaController = new SvgaController({
    loops: Infinity,                    // 播放3次
    fillMode: 'forwards',        // 播放结束后停留在最后一帧
    pageUpdateMode: 'pause',     // 页面切换时暂停动画
    autoRelease: true,           // 页面销毁时自动释放资源
    clearsAfterStop: true        // 停止播放后清理资源
  });
  @Prop  params: Params;
  private svgaPlayerView: SvgaPlayerView = this.params.platformView as SvgaPlayerView
  @StorageLink('url') @Watch('__watchUrlChange')  storageLink: string = ""
  @State bkColor: Color = Color.Red
  __watchUrlChange(){
    this.controller.load('https://raw.githubusercontent.com/yyued/SVGAPlayer-iOS/master/SVGAPlayer/Samples/Goddess.svga');
  }
  build() {
    // 声明式UI 2.0版本组件
    SvgaPlayerV2({
      url:this.storageLink,
      controller: this.controller
    })
  }
}