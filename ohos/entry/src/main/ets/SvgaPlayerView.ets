import MethodChannel, {
        MethodCallHandler,
        MethodResult
        } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import PlatformView, { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import common from '@ohos.app.ability.common';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import StandardMethodCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMethodCodec';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import { SvgaPlayerComponent } from './SvgaPlayerComponent';

@Builder
function SvgaPlayerBuilder(params: Params) {
    SvgaPlayerComponent({ params: params })
}

@Observed
export class SvgaPlayerView extends PlatformView implements MethodCallHandler {
    url: string = "";

    methodChannel: MethodChannel;
    index: number = 1;

    constructor(context: common.Context, viewId: number, args: ESObject, message: BinaryMessenger) {
        super();
        console.log("nodeController viewId:" + viewId)
        // 注册消息通道，消息通道根据具体需求添加，代码仅作为示例
        this.methodChannel = new MethodChannel(message, `com.rex.custom.ohos/customView${viewId}`, StandardMethodCodec.INSTANCE);
        this.methodChannel.setMethodCallHandler(this);
    }

    onMethodCall(call: MethodCall, result: MethodResult): void {
        // 接受Dart侧发来的消息
        let method: string = call.method;
        let link: SubscribedAbstractProperty<number> = AppStorage.link('url');
        switch (method) {
            case 'getMessageFromFlutterView':
                let value: ESObject = call.args;
                this.url = value;
                link.set(value)
                result.success(true);
                break;
        }
    }

    public sendMessage = () => {
        console.log("nodeController sendMessage")
        //向Dart侧发送消息
        this.methodChannel.invokeMethod('getMessageFromOhosView', 'natvie - ' + this.index++);
    }

    getView(): WrappedBuilder<[Params]> {
        return new WrappedBuilder(SvgaPlayerBuilder);
    }

    dispose(): void {
    }
}