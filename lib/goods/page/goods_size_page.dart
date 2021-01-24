
import 'package:flutter/material.dart';
import 'package:flutter_deer/goods/models/goods_size_model.dart';
import 'package:flutter_deer/goods/widgets/goods_size_dialog.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_deer/util/image_utils.dart';
import 'package:flutter_deer/util/toast.dart';
import 'package:flutter_deer/util/other_utils.dart';
import 'package:flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_deer/widgets/load_image.dart';
import 'package:flutter_deer/widgets/my_button.dart';
import 'package:flutter_deer/widgets/popup_window.dart';
import 'package:flutter_deer/widgets/state_layout.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../goods_router.dart';

/// design/4商品/index.html#artboard9
class GoodsSizePage extends StatefulWidget {
  @override
  _GoodsSizePageState createState() => _GoodsSizePageState();
}

class _GoodsSizePageState extends State<GoodsSizePage> {
  
  bool _isEdit = false;
  String _sizeName = '商品规格名称';
  final GlobalKey _hintKey = GlobalKey();

  final List<GoodsSizeModel> _goodsSizeList = [];
  // 保留一个Slidable打开
  final SlidableController _slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    _goodsSizeList.clear();
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_1', '黑色', 1000, '50.0', 2, '2', '2', '2'));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_2', '银色', 100, '51.0', 1, '', '2', '1'));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_1', '黑色1', 1050, '50.0', 2, '20', '2', ''));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_2', '银色1', 1000, '55.0', 2, '', '10', '2'));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_1', '黑色2', 500, '56', 2, '2', '2', '2'));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_2', '银色2', 110, '51.0', 2, '2', '1', ''));
    _goodsSizeList.add(GoodsSizeModel('goods/goods_size_1', '黑色3', 10, '50.0', 2, '2', '2.5', ''));

    // 获取Build完成状态监听
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _showHint();
    });
  }

  /// design/4商品/index.html#artboard18
  void _showHint() {
    final RenderBox hint = _hintKey.currentContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final a = hint.localToGlobal(Offset(50.0, hint.size.height + 150.0), ancestor: overlay);
    final b = hint.localToGlobal(hint.size.bottomLeft(const Offset(50.0, 150.0)), ancestor: overlay);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    showPopupWindow<void>(
      context: context,
      fullWidth: false,
      isShowBg: true,
      position: position,
      elevation: 0.0,
      child: Semantics(
        label: '弹出引导页',
        hint: '向左滑动可删除列表，点击可关闭',
        button: true,
        child: Container(
          key: const Key('hint'),
          width: 200.0,
          height: 147.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageUtils.getAssetImage('goods/ydss'),
              fit: BoxFit.fitWidth
            )
          ),
        ),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        key: _hintKey,
        title: '商品规格',
        actionName: '保存',
        onPressed: () {
          Toast.show('保存');
          NavigatorUtils.goBack(context);
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Gaps.vGap16,
            Text(
              _sizeName,
              style: TextStyles.textBold24,
            ),
            InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return GoodsSizeDialog(
                      onPressed: (name) {
                        setState(() {
                          _sizeName = name;
                          _isEdit = true;
                        });
                      },
                    );
                  }
                );
              },
              child: Padding(
                // 扩大点击范围
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  key: const Key('name_edit'),
                  text: TextSpan(
                    text: '先对名称进行',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: Dimens.font_sp14),
                    children: <TextSpan>[
                      TextSpan(text: '编辑', style: TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  )
                ),
              ),
            ),
            Gaps.vGap24,
            Expanded(
              child: _goodsSizeList.isEmpty ? const StateLayout(
                type: StateType.goods,
                hintText: '暂无商品规格',
              ) : ListView.builder(
                itemCount: _goodsSizeList.length,
                itemExtent: 107.0,
                itemBuilder: (_, index) => _getGoodsSizeItem(index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MyButton(
                onPressed: _isEdit ? () {
                  NavigatorUtils.push(context, GoodsRouter.goodsSizeEditPage);
                } : null,
                text: '添加',
              ),
            )
          ],
        ),
      ),
    );
  }
 
  /// design/4商品/index.html#artboard19
  Widget _getGoodsSizeItem(int index) {

    // item
    Widget widget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LoadAssetImage(_goodsSizeList[index].icon, width: 72.0, height: 72.0),
        Gaps.hGap8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _goodsSizeList[index].sizeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '库存${_goodsSizeList[index].stock}',
                    style: TextStyles.textSize12,
                  ),
                ],
              ),
              Gaps.vGap4,
              Row(
                children: <Widget>[
                  Offstage(
                    offstage: _goodsSizeList[index].reducePrice.isEmpty,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      margin: const EdgeInsets.only(right: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).errorColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      height: 16.0,
                      alignment: Alignment.center,
                      child: Text(
                        '立减${_goodsSizeList[index].reducePrice}元',
                        style: const TextStyle(color: Colors.white, fontSize: Dimens.font_sp10),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _goodsSizeList[index].currencyPrice.isEmpty ? 0.0 : 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      height: 16.0,
                      alignment: Alignment.center,
                      child: Text(
                        '社区币抵扣${_goodsSizeList[index].currencyPrice}元',
                        style: const TextStyle(color: Colors.white, fontSize: Dimens.font_sp10),
                      ),
                    ),
                  )
                ],
              ),
              Gaps.vGap16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Utils.formatPrice(_goodsSizeList[index].price)),
                  const SizedBox(width: 50.0,),
                  Text(
                    '佣金${_goodsSizeList[index].charges}元',
                    style: TextStyles.textSize12,
                  ),
                  Text(
                    '起购${_goodsSizeList[index].minSaleNum}件',
                    style: TextStyles.textSize12,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );

    // item装饰
    widget = InkWell(
      onTap: () {
        /// 如果侧滑菜单打开，关闭侧滑菜单。否则跳转
        if (_slidableController.activeState != null) {
          _slidableController.activeState.close();
        } else {
          NavigatorUtils.push(context, GoodsRouter.goodsSizeEditPage);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context, width: 0.8),
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: widget
          ),
        ),
      ),
    );

    // 侧滑删除
    return Slidable(
      key: Key(index.toString()),
      controller: _slidableController,
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.20, 
      ///右侧的action
      secondaryActions: <Widget>[
        SlideAction(
          child: Semantics(
            label: '删除',
            child: Container(
              width: 72.0,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LoadAssetImage('goods/goods_delete', key: Key('delete_$index'),),
            ),
          ),
          color: Theme.of(context).errorColor,
          onTap: () {
            setState(() {
              _goodsSizeList.removeAt(index);
            });
          },
        ),
      ],
      child: widget
    );
  }
}
