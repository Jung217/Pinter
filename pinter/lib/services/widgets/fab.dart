import 'package:flutter/material.dart';
import 'package:ritual/services/constants.dart';
import 'package:ritual/services/shared_prefs.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

// Services
import 'package:ritual/services/misc.dart';
import 'package:ritual/services/ritual_icons.dart';

class ExpandableFab extends StatefulWidget {
  final bool sprint;
  final bool highlight;

  const ExpandableFab({super.key, required this.sprint, required this.highlight});

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  // FAB Expanded State
  bool _isExpanded = false;

  // A copy of appSetupTrackerFab
  bool appSetupTrackerFab = !SharedPreferencesManager()
      .getAppSetupTracker(Constants.appSetupTrackerFab);

  @override
  Widget build(BuildContext context) {
    return SpotlightShow(
      child: Stack(
        children: [
          if (_isExpanded) _buildModalBarrier(),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Highlights Commit Extended FAB
                if (_isExpanded && widget.highlight)
                  SpotlightAnt(
                    enable: appSetupTrackerFab,
                    content: Misc.spotlightText(
                        "Tap here to create a new Highlight"),
                    child: _buildExpandableFab(
                      onPressed: () {
                        Navigator.pushNamed(context, "/commit/highlight",
                            arguments: {"mode": "new"});
                        _collapseFAB();
                      },
                      icon: const Icon(CustomIcons.lightbulbOutline),
                      tooltip: 'Set Highlight',
                    ),
                  ),

                // Sprints Commit Extended FAB
                if (_isExpanded && widget.highlight) const SizedBox(height: 8),
                if (_isExpanded && widget.sprint)
                  SpotlightAnt(
                    enable: appSetupTrackerFab,
                    content: Misc.spotlightText("Tap to commit to a new Sprint"),
                    child: _buildExpandableFab(
                      onPressed: () {
                        Navigator.pushNamed(context, "/commit/sprint",
                            arguments: {"mode": "new"});
                        _collapseFAB();
                      },
                      icon: const Icon(CustomIcons.directionsRun),
                      tooltip: 'Set Sprint',
                    ),
                  ),
                if (_isExpanded && widget.sprint) const SizedBox(height: 8),

                // Ritual Commit Extended FAB
                if (_isExpanded)
                  SpotlightAnt(
                    enable: appSetupTrackerFab,
                    content:
                        Misc.spotlightText("Tap to commit to a new Ritual"),
                    child: _buildExpandableFab(
                      onPressed: () {
                        Navigator.pushNamed(context, "/commit/ritual",
                            arguments: {"mode": "new"});
                        _collapseFAB();
                      },
                      icon: const Icon(CustomIcons.fire),
                      tooltip: 'New Ritual',
                    ),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  tooltip: _isExpanded ? 'Collapse' : 'Expand',
                  child: Icon(_isExpanded ? Icons.close : Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableFab({
    required VoidCallback onPressed,
    required Icon icon,
    required String tooltip,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          heroTag: null,
          tooltip: tooltip,
          child: icon,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildModalBarrier() {
    debugPrint("appSetupTrackerFab: $appSetupTrackerFab");

    // Set the demo complete
    SharedPreferencesManager().setAppSetupTracker(Constants.appSetupTrackerFab);
    appSetupTrackerFab = false;

    return GestureDetector(
      onTapDown: (details) => _collapseFAB(),
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  void _collapseFAB() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }
}
