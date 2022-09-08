// Original Author: Bilal Shahid (bilalscheema@gmail.com)
// Version 2 maintained by: Jannis Berndt (berndtjannis@gmail.com)

part of persistent_bottom_nav_bar_v2;

/// A highly customizable persistent bottom navigation bar for flutter.
///
/// To learn more, check out the [Readme](https://github.com/jb3rndt/PersistentBottomNavBarV2).
class PersistentTabView extends StatefulWidget {
  /// List of persistent bottom navigation bar items to be displayed in the navigation bar.
  final List<PersistentBottomNavBarItem>? items;

  /// Screens that will be displayed on tapping of persistent bottom navigation bar items.
  final List<Widget> screens;

  /// Controller for persistent bottom navigation bar. Will be declared if left empty.
  final PersistentTabController? controller;

  /// Background color of bottom navigation bar. `white` by default.
  final Color colorBehindNavBar;

  /// Callback when page or tab change is detected.
  final ValueChanged<int>? onItemSelected;

  /// A custom widget which is displayed at the bottom right of the display at all times.
  final Widget? floatingActionButton;

  /// Position of the floating action button from the bottom right corner.
  /// `Offset(10, 10)` by default.
  final Offset floatingActionButtonOffset;

  /// Specifies the navBarHeight
  ///
  /// Defaults to `kBottomNavigationBarHeight` which is `56.0`.
  final double navBarHeight;

  /// Specifies how much the navBar should float above
  /// the tab content. Defaults to [NavBarOverlap.full].
  final NavBarOverlap navBarOverlap;

  /// The margin around the navigation bar.
  final EdgeInsets margin;

  /// TODO update doc:
  /// Builder for the Navigation Bar Widget. This also exposes
  /// [NavBarEssentials] for further control. You can either pass a custom
  /// Widget or choose one of the predefined Navigation Bars.
  final Widget Function(NavBarEssentials) navBarBuilder;

  /// If using `custom` navBarStyle, define this instead of the `items` property
  final int? itemCount;

  /// Will confine the NavBar's items in the safe area defined by the device.
  final bool confineInSafeArea;

  /// Handles android back button actions. Defaults to `true`.
  ///
  /// Action based on scenarios:
  /// 1. If the you are on the first tab with all screens popped of the given tab, the app will close.
  /// 2. If you are on another tab with all screens popped of that given tab, you will be switched to first tab.
  /// 3. If there are screens pushed on the selected tab, a screen will pop on a respective back button press.
  final bool handleAndroidBackButtonPress;

  /// If an already selected tab is pressed/tapped again, all the screens pushed
  /// on that particular tab will pop until the first screen in the stack.
  /// Defaults to `true`.
  final bool popAllScreensOnTapOfSelectedTab;

  /// If set all pop until to first screen else set once pop once
  final PopActionScreensType? popActionScreens;

  final bool resizeToAvoidBottomInset;

  /// Preserves the state of each tab's screen. `true` by default.
  final bool stateManagement;

  /// If you want to perform a custom action on Android when exiting the app,
  /// you can write your logic here. Returns context of the selected screen.
  final Future<bool> Function(BuildContext?)? onWillPop;

  /// Returns the context of the selected tab.
  final Function(BuildContext?)? selectedTabScreenContext;

  /// Screen transition animation properties when switching tabs.
  final ScreenTransitionAnimation screenTransitionAnimation;

  final bool hideNavigationBarWhenKeyboardShows;

  /// Hides the navigation bar with a transition animation.
  /// Use it in conjuction with [Provider](https://pub.dev/packages/provider)
  /// for better results.
  final bool hideNavigationBar;

  /// Define navigation bar route name and settings here.
  ///
  /// If you want to programmatically pop to initial screen on a specific
  /// use this route name when popping.
  final CustomWidgetRouteAndNavigatorSettings? routeAndNavigatorSettings;

  final bool isCustomWidget;

  final BuildContext context;

  /// Creates a fullscreen container with a navigation bar at the bottom. The
  /// navigation bar style can be chosen from [NavBarStyle]. If you want to
  /// make a custom style use [PersistentTabView.custom].
  ///
  /// The different screens get displayed in the container when an item is
  /// selected in the navigation bar.
  PersistentTabView(
    this.context, {
    Key? key,
    this.items,
    required this.screens,
    required this.navBarBuilder,
    this.controller,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.margin = EdgeInsets.zero,
    this.colorBehindNavBar = Colors.white,
    this.onItemSelected,
    this.floatingActionButton,
    this.floatingActionButtonOffset = const Offset(10, 10),
    this.resizeToAvoidBottomInset = true,
    this.selectedTabScreenContext,
    this.hideNavigationBarWhenKeyboardShows = true,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.popActionScreens = PopActionScreensType.all,
    this.confineInSafeArea = true,
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
  })  : assert(items != null,
            "Items can only be null in case of custom navigation bar style. Please add the items!"),
        assert(
            assertMidButtonStyles(NavBarStyle.style1,
                items!.length), //TODO do something senseful with this
            "NavBar styles 15-18 only accept 3 or 5 PersistentBottomNavBarItem items."),
        assert(items!.length == screens.length,
            "screens and items length should be same. If you are using the onPressed callback function of 'PersistentBottomNavBarItem', enter a dummy screen like Container() in its place in the screens"),
        assert(items!.length >= 2 && items.length <= 6,
            "NavBar should have at least 2 or maximum 6 items (Except for styles 15-18)"),
        this.isCustomWidget = false,
        this.itemCount = items?.length,
        this.routeAndNavigatorSettings = null,
        super(key: key);

  /// Creates a fullscreen container with a navigation bar at the bottom. The
  /// navigation bar has to be built by hand in the [customWidget] builder. This
  /// also exposes [NavBarEssentials] to have more control over the navbar
  /// behavior.
  ///
  /// The different screens get displayed in the container when an item is
  /// selected in the navigation bar.
  PersistentTabView.custom(
    this.context, {
    Key? key,
    required this.screens,
    this.controller,
    this.margin = EdgeInsets.zero,
    this.floatingActionButton,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.floatingActionButtonOffset = const Offset(10, 10),
    required this.itemCount,
    required this.navBarBuilder,
    this.resizeToAvoidBottomInset = true,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.selectedTabScreenContext,
    this.hideNavigationBarWhenKeyboardShows = true,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.colorBehindNavBar = Colors.white,
    this.routeAndNavigatorSettings =
        const CustomWidgetRouteAndNavigatorSettings(),
    this.confineInSafeArea = true,
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
  })  : assert(itemCount == screens.length,
            "screens and items length should be same. If you are using the onPressed callback function of 'PersistentBottomNavBarItem', enter a dummy screen like Container() in its place in the screens"),
        assert(
            routeAndNavigatorSettings!.navigatorKeys == null ||
                routeAndNavigatorSettings.navigatorKeys != null &&
                    routeAndNavigatorSettings.navigatorKeys!.length !=
                        itemCount,
            "Number of 'Navigator Keys' must be equal to the number of bottom navigation tabs."),
        this.isCustomWidget = true,
        this.items = null,
        this.onItemSelected = null,
        this.popActionScreens = null,
        super(key: key);

  @override
  _PersistentTabViewState createState() => _PersistentTabViewState();
}

class _PersistentTabViewState extends State<PersistentTabView> {
  late List<BuildContext?> _contextList;
  late PersistentTabController _controller;
  bool _hideNavBarDueToKeyboard = false;
  late int _previousIndex;
  late int _currentIndex;
  bool _sendScreenContext = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? PersistentTabController(initialIndex: 0);

    _contextList = List<BuildContext?>.filled(
        widget.items == null ? widget.itemCount ?? 0 : widget.items!.length,
        null);

    _previousIndex = _controller.index;
    _currentIndex = _controller.index;

    _controller.addListener(() {
      if (_controller.index != _currentIndex) {
        if (widget.selectedTabScreenContext != null) {
          _sendScreenContext = true;
        }
        if (mounted)
          setState(
            () => _currentIndex = _controller.index,
          );
      }
    });
    if (widget.selectedTabScreenContext != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        widget.selectedTabScreenContext!(_contextList[_controller.index]);
      });
    }
  }

  Widget _buildScreen(int index) {
    RouteAndNavigatorSettings _routeAndNavigatorSettings = widget.isCustomWidget
        ? RouteAndNavigatorSettings(
            defaultTitle: widget.routeAndNavigatorSettings!.defaultTitle,
            initialRoute: widget.routeAndNavigatorSettings!.initialRoute,
            navigatorKey:
                widget.routeAndNavigatorSettings!.navigatorKeys == null
                    ? null
                    : widget.routeAndNavigatorSettings!.navigatorKeys![index],
            navigatorObservers: widget
                    .routeAndNavigatorSettings!.navigatorObservers.isEmpty
                ? []
                : widget.routeAndNavigatorSettings!.navigatorObservers[index],
            onGenerateRoute: widget.routeAndNavigatorSettings!.onGenerateRoute,
            onUnknownRoute: widget.routeAndNavigatorSettings!.onUnknownRoute,
            routes: widget.routeAndNavigatorSettings!.routes,
          )
        : widget.items![index].routeAndNavigatorSettings;

    if (widget.floatingActionButton != null) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SizedBox.expand(
            child: CustomTabView(
              routeAndNavigatorSettings: _routeAndNavigatorSettings,
              builder: (BuildContext screenContext) {
                _contextList[index] = screenContext;
                if (_sendScreenContext) {
                  _sendScreenContext = false;
                  widget.selectedTabScreenContext!(
                      _contextList[_controller.index]);
                }
                return Material(elevation: 0, child: widget.screens[index]);
              },
            ),
          ),
          Positioned(
            bottom: widget.floatingActionButtonOffset.dy,
            right: widget.floatingActionButtonOffset.dx,
            child: widget.floatingActionButton!,
          ),
        ],
      );
    } else {
      return CustomTabView(
          routeAndNavigatorSettings: _routeAndNavigatorSettings,
          builder: (BuildContext screenContext) {
            _contextList[index] = screenContext;
            if (_sendScreenContext) {
              _sendScreenContext = false;
              widget.selectedTabScreenContext!(_contextList[_controller.index]);
            }
            return Material(
              elevation: 0,
              child: widget.screens[index],
              type: MaterialType.transparency,
            );
          });
    }
  }

  Widget navigationBarWidget() => CupertinoPageScaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        backgroundColor: Colors.transparent,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(
                bottom: 100), // TODO: Simulate gesture bar
          ),
          child: PersistentTabScaffold(
            controller: _controller,
            hideNavigationBar:
                widget.hideNavigationBar || _hideNavBarDueToKeyboard,
            itemCount: widget.items == null
                ? widget.itemCount ?? 0
                : widget.items!.length,
            stateManagement: widget.stateManagement,
            colorBehindNavBar: widget.colorBehindNavBar,
            navBarOverlap: widget.navBarOverlap,
            opacities: widget.items?.map((e) => e.opacity).toList() ?? [],
            navBarHeight: widget.navBarHeight,
            screenTransitionAnimation: widget.screenTransitionAnimation,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            tabBar: PersistentBottomNavBar(
              margin: widget.margin,
              confineToSafeArea:
                  widget.confineInSafeArea, // TODO: Name consistently
              child: widget.navBarBuilder(NavBarEssentials(
                selectedIndex: _controller.index,
                previousIndex: _previousIndex,
                selectedScreenBuildContext: _contextList[_controller.index],
                items: widget.items,
                navBarHeight: widget.navBarHeight,
                popScreensOnTapOfSelectedTab:
                    widget.popAllScreensOnTapOfSelectedTab,
                onItemSelected: (int index) {
                  if (_controller.index != _previousIndex) {
                    _previousIndex = _controller.index;
                  }
                  if ((widget.popAllScreensOnTapOfSelectedTab) &&
                      _previousIndex == index) {
                    popAllScreens();
                  }
                  _controller.index = index;
                  widget.onItemSelected?.call(index);
                },
              )),
            ),
            tabBuilder: (BuildContext context, int index) {
              return _buildScreen(index);
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool isKeyboardUp = MediaQuery.of(widget.context).viewInsets.bottom > 0;
    _hideNavBarDueToKeyboard =
        isKeyboardUp && widget.hideNavigationBarWhenKeyboardShows;
    if (_contextList.length != (widget.itemCount ?? widget.items!.length)) {
      _contextList = List<BuildContext?>.filled(
          (widget.items == null ? widget.itemCount ?? 0 : widget.items!.length),
          null);
    }
    if (widget.handleAndroidBackButtonPress || widget.onWillPop != null) {
      return WillPopScope(
        onWillPop:
            !widget.handleAndroidBackButtonPress && widget.onWillPop != null
                ? () => widget.onWillPop!(_contextList[_controller.index])
                : () async {
                    if (_controller.index == 0 &&
                        !Navigator.canPop(_contextList.first!)) {
                      if (widget.handleAndroidBackButtonPress &&
                          widget.onWillPop != null) {
                        return widget.onWillPop!(_contextList.first);
                      }
                      return true;
                    } else {
                      if (Navigator.canPop(_contextList[_controller.index]!)) {
                        Navigator.pop(_contextList[_controller.index]!);
                      } else {
                        if (widget.onItemSelected != null) {
                          widget.onItemSelected!(0);
                        }
                        _controller.index = 0;
                      }
                      return false;
                    }
                  },
        child: navigationBarWidget(),
      );
    } else {
      return navigationBarWidget();
    }
  }

  void popAllScreens() {
    if (widget.popAllScreensOnTapOfSelectedTab) {
      if (widget.items![_controller.index]
                  .onSelectedTabPressWhenNoScreensPushed !=
              null &&
          !Navigator.of(_contextList[_controller.index]!).canPop()) {
        widget
            .items![_controller.index].onSelectedTabPressWhenNoScreensPushed!();
      }

      if (widget.popActionScreens == PopActionScreensType.once) {
        if (Navigator.of(_contextList[_controller.index]!).canPop()) {
          Navigator.of(_contextList[_controller.index]!).pop(context);
          return;
        }
      } else {
        Navigator.popUntil(
            _contextList[_controller.index]!,
            ModalRoute.withName(widget.isCustomWidget
                ? (widget.routeAndNavigatorSettings?.initialRoute ??
                    '/9f580fc5-c252-45d0-af25-9429992db112')
                : widget.items![_controller.index].routeAndNavigatorSettings
                        .initialRoute ??
                    '/9f580fc5-c252-45d0-af25-9429992db112'));
      }
    }
  }
}

//asserts

bool assertMidButtonStyles(NavBarStyle navBarStyle, int itemCount) {
  if (navBarStyle == NavBarStyle.style15 ||
      navBarStyle == NavBarStyle.style16 ||
      navBarStyle == NavBarStyle.style17 ||
      navBarStyle == NavBarStyle.style18) {
    if (itemCount % 2 != 0) {
      return true;
    } else {
      return false;
    }
  }
  return true;
}
