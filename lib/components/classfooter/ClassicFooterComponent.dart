
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trans/extension/StringExtension.dart';

///the most common indicator,combine with a text and a icon
///
// See also:
//
// [ClassicHeader]
class ClassicFooterComponent extends LoadIndicator {
  final String idleText, loadingText, noDataText, failedText, canLoadingText;

  /// a builder for re wrap child,If you need to change the boxExtent or background,padding etc.you need outerBuilder to reWrap child
  /// example:
  /// ```dart
  /// outerBuilder:(child){
  ///    return Container(
  ///       color:Colors.red,
  ///       child:child
  ///    );
  /// }
  /// ````
  /// In this example,it will help to add backgroundColor in indicator
  final OuterBuilder outerBuilder;

  final Widget
//  idleIcon,
      loadingIcon,
      noMoreIcon;
//      failedIcon;
//      canLoadingIcon


  /// icon and text middle margin
  final double spacing;

  final IconPosition iconPos;

//  final TextStyle textStyle;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  final Map stylesColor;
  final Map strings;

  const ClassicFooterComponent({
    Key key,
    VoidCallback onClick,
    LoadStyle loadStyle: LoadStyle.ShowAlways,
    double height: 60.0,
    this.stylesColor,
    this.strings,
    this.outerBuilder,
    this.loadingText,
    this.noDataText,
    this.noMoreIcon,
    this.idleText,
    this.failedText,
    this.canLoadingText,
    this.iconPos: IconPosition.left,
    this.spacing: 10.0,
    this.completeDuration: const Duration(milliseconds: 300),
    this.loadingIcon,
  }) : super(
    key: key,
    loadStyle: loadStyle,
    height: height,
    onClick: onClick,
  );

  @override
  State<StatefulWidget> createState() {
    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends LoadIndicatorState<ClassicFooterComponent> {
  Widget _buildText(LoadStatus mode) {
    RefreshString strings =
        RefreshLocalizations.of(context)?.currentLocalization ??
            EnRefreshString();

    TextStyle textStyle;
    String canLoadingText;
    String loadFailedText;
    String loadingText;
    String idleText;
    if(mode == LoadStatus.canLoading) {
      String canLoadingString = widget.stylesColor['can_loading_color'];
      Color canLoadingColor = canLoadingString.toColorObj(
          defaultColor: Color(0xffDB0000));
      textStyle = TextStyle(color: canLoadingColor);
      canLoadingText = widget.strings['can_loading_text'];
      if(canLoadingText == null || canLoadingText == ''){
        canLoadingText = 'Release to load more';
      }
    }else if(mode == LoadStatus.loading) {
      String loadingString = widget.stylesColor['loading_color'];
      Color loadingColor = loadingString.toColorObj(
          defaultColor: Color(0xffDB0000));
      textStyle = TextStyle(color: loadingColor);
      loadingText = widget.strings['loading_text'];
      if(loadingText == null || loadingText == ''){
        loadingText = 'Loading...';
      }
      
    }else if(mode == LoadStatus.idle) {
      String idleLoadingString = widget.stylesColor['idle_loading_color'];
      Color idleLoadingColor = idleLoadingString.toColorObj(
          defaultColor: Color(0xffDB0000));
      textStyle = TextStyle(color: idleLoadingColor);
      idleText = widget.strings['idle_loading_text'];
      if(idleText == null || idleText == ''){
        idleText = 'Pull up load more';
      }

    }else if(mode == LoadStatus.failed){
      String failString = widget.stylesColor['fail_color'];
      Color failColor = failString.toColorObj(defaultColor: Color(0xffDB0000));
      textStyle = TextStyle(color: failColor);
      loadFailedText = widget.strings['load_failed_text'];
      if(loadFailedText == null || loadFailedText == ''){
        loadFailedText = 'Load failed';
      }
      
    }else{
      const TextStyle(color: Color(0xffDB0000));
    }

    return Text(
        mode == LoadStatus.loading
            ? loadingText
            : LoadStatus.noMore == mode
            ? widget.noDataText ?? strings.noMoreText
            : LoadStatus.failed == mode
            ? loadFailedText
            : LoadStatus.canLoading == mode
            ? canLoadingText
            : idleText,
        style: textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {

    String canLoadingString = widget.stylesColor['can_loading_color'];
    Color canLoadingColor = canLoadingString.toColorObj(defaultColor: Color(0xffDB0000));
    Widget canLoadingIcon =   Icon(Icons.autorenew, color: canLoadingColor);

    String loadingString = widget.stylesColor['loading_color'];
    Color loadingColor = loadingString.toColorObj(defaultColor: Color(0xffDB0000));

    String idleLoadingString = widget.stylesColor['idle_loading_color'];
    Color idleLoadingColor = idleLoadingString.toColorObj(defaultColor: Color(0xffDB0000));
    Widget idleLoadingIcon =   Icon(Icons.arrow_upward, color: idleLoadingColor);


    String failString = widget.stylesColor['fail_color'];
    Color failColor = failString.toColorObj(defaultColor: Color(0xffDB0000));
    Widget failIcon =  Icon(Icons.error, color: failColor);

    Widget icon = mode == LoadStatus.loading
        ? widget.loadingIcon ??
        SizedBox(
          width: 25.0,
          height: 25.0,
          child: SpinKitFadingCube(color: loadingColor, size: 15),
        )
        : mode == LoadStatus.noMore
        ? widget.noMoreIcon
        : mode == LoadStatus.failed
        ? failIcon
        : mode == LoadStatus.canLoading
        ? canLoadingIcon
        : idleLoadingIcon;
    return icon ?? Container(width: 0, height: 0);
  }

  @override
  Future endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
          widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
      height: widget.height,
      child: Center(
        child: container,
      ),
    );
  }
}
