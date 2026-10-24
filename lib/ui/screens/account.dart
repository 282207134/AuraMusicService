import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';
import '../widgets/common.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuraLogo(size: 40),
                  IconButton(
                    tooltip: 'Close menu',
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        goHome(context);
                      }
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 38),
              InkWell(
                onTap: () => go(context, AppRoute.profile),
                child: Row(
                  children: [
                    const Art('portrait', width: 52, height: 52, radius: 26),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            state.email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: context.aura.secondary),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              for (final route in [
                AppRoute.home,
                AppRoute.library,
                AppRoute.recommendations,
                AppRoute.genres,
                AppRoute.radio,
                AppRoute.events,
                AppRoute.aura,
                AppRoute.settings,
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    route.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: context.aura.secondary,
                    ),
                  ),
                  onTap: () => route == AppRoute.home
                      ? goHome(context)
                      : go(context, route),
                  trailing: route == AppRoute.aura
                      ? const AuraLogo(size: 20)
                      : null,
                ),
              const Divider(height: 35),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Discover Aura',
                  style: TextStyle(fontSize: 17),
                ),
                subtitle: const Text(
                  'Introduction & your music taste',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => go(context, AppRoute.onboard1),
              ),
              TextButton(
                onPressed: () {
                  go(context, AppRoute.login);
                },
                child: const Text(
                  'SWITCH LOCAL PROFILE',
                  style: TextStyle(color: AuraColors.pink, fontSize: 12),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'AURA MUSIC   /   1.0',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: context.aura.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.initialPage});
  final int initialPage;
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pages = PageController(
    initialPage: widget.initialPage,
  );
  late int page = widget.initialPage;
  static const titles = [
    'Millions of tracks',
    'Playlists for any mood',
    'New music every day',
    'Your music, everywhere',
    'High sound quality',
  ];
  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: _pages,
            itemCount: 5,
            onPageChanged: (i) => setState(() => page = i),
            itemBuilder: (context, index) => Stack(
              fit: StackFit.expand,
              children: [
                Art('onboard-${index + 1}', radius: 0),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x33000000), Color(0x99000000)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AuraLogo(size: 38),
                    TextButton(
                      onPressed: () => goHome(context),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 5),
                Text(
                  titles[page],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 5; i++)
                      GestureDetector(
                        onTap: () => _pages.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: i == page ? 8 : 6,
                          height: i == page ? 8 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == page ? AuraColors.cyan : Colors.white54,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(flex: 1),
                GradientButton(
                  "I'M A NEW USER",
                  onPressed: () => go(context, AppRoute.welcome),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () => go(context, AppRoute.login),
                    child: const Text(
                      'I have an account · ENTER',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false});
  final bool register;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool obscure = true;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.register ? 'WELCOME' : 'LOGIN',
    miniPlayer: false,
    action: const SizedBox.shrink(),
    child: Form(
      key: _form,
      child: Column(
        children: [
          const SizedBox(height: 35),
          const AuraLogo(size: 76),
          const SizedBox(height: 30),
          const Text(
            'Create a local profile and listen to\nyour favorite music on this device',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textInputAction: TextInputAction.next,
            validator: (value) =>
                (value?.trim().length ?? 0) < 2 ? 'Enter your name' : null,
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            textInputAction: TextInputAction.next,
            validator: (value) =>
                RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                    .hasMatch(value?.trim() ?? '')
                ? null
                : 'Enter a valid email address',
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _password,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                tooltip: 'Show password',
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) =>
                (value?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
          ),
          const SizedBox(height: 25),
          GradientButton(
            widget.register
                ? 'REGISTER LOCAL PROFILE'
                : 'CONTINUE WITH LOCAL PROFILE',
            onPressed: () async {
              if (!_form.currentState!.validate()) return;
              await MusicScope.of(context)
                  .updateProfile(_name.text, _email.text);
              if (context.mounted) {
                if (widget.register) {
                  go(context, AppRoute.hello);
                } else {
                  goHome(context);
                }
              }
            },
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'or',
                  style: TextStyle(color: context.aura.secondary),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () => goHome(context),
            child: const Text('Continue as guest'),
          ),
          const SizedBox(height: 20),
          Text(
            'Local demo account. No online authentication.\nYour password is never stored.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: context.aura.secondary),
          ),
        ],
      ),
    ),
  );
}

class TasteScreen extends StatelessWidget {
  const TasteScreen({super.key, required this.route});
  final AppRoute route;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    if (route == AppRoute.tasteResult) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: context.aura.gradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  const Text(
                    'Complete!',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const Spacer(),
                  const Icon(Icons.graphic_eq, size: 90, color: Colors.white),
                  const SizedBox(height: 50),
                  Text(
                    state.selectedGenres.contains('Rock')
                        ? 'Rebel'
                        : 'Explorer',
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Your sound: ${state.selectedGenres.join(', ')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => go(context, AppRoute.recommendations),
                    child: const Text(
                      'VIEW RECOMMENDATIONS',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return PageFrame(
      title: route == AppRoute.hello ? '' : route.title,
      miniPlayer: false,
      action: TextButton(
        onPressed: () => goHome(context),
        child: Text('Skip', style: TextStyle(color: context.aura.secondary)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 35),
          if (route == AppRoute.hello) ...[
            const AuraLogo(size: 90),
            const SizedBox(height: 65),
            Text(
              'Hello, ${state.name}.\nMy name is Aura.',
              style: const TextStyle(fontSize: 27, height: 1.5),
            ),
            const SizedBox(height: 35),
            const Text(
              'I want to know your\nmusical taste.',
              style: TextStyle(fontSize: 26, height: 1.5),
            ),
            const SizedBox(height: 90),
            GradientButton(
              'START',
              onPressed: () => go(context, AppRoute.taste),
            ),
          ] else if (route == AppRoute.taste) ...[
            Text(
              'A sound for every side of you.',
              style: TextStyle(color: context.aura.secondary),
            ),
            const SizedBox(height: 35),
            SizedBox(
              height: 350,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 18,
                  children:
                      [
                        'Lounge',
                        'Jazz',
                        'Classic',
                        'Alternative',
                        'Rock',
                        'Punk',
                        'Metal',
                        'Blues',
                        'R&B',
                        'Pop',
                        'Rap',
                      ].map((genre) {
                        final selected = state.selectedGenres.contains(genre);
                        return GestureDetector(
                          onTap: () => state.toggleGenre(genre),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: genre == 'Alternative' ? 108 : 75,
                            height: genre == 'Alternative' ? 108 : 75,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: selected ? context.aura.gradient : null,
                              color: selected
                                  ? null
                                  : Theme.of(context).colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: AuraColors.blue.withValues(alpha: .12),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : context.aura.secondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 35),
            GradientButton(
              'NEXT',
              onPressed: state.selectedGenres.isEmpty
                  ? null
                  : () => go(context, AppRoute.songTaste),
            ),
          ] else ...[
            const Disc('taste-song', size: 260),
            const SizedBox(height: 35),
            const Text('Hallow Fate', style: TextStyle(fontSize: 23)),
            Text(
              'Gin Wigmore',
              style: TextStyle(color: context.aura.secondary),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAction(
                  Icons.close,
                  label: 'Skip song',
                  onPressed: () => go(context, AppRoute.tasteResult),
                ),
                const SizedBox(width: 25),
                CircleAction(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  label: 'Listen to sample',
                  onPressed: state.togglePlayback,
                  primary: true,
                  size: 80,
                ),
                const SizedBox(width: 25),
                CircleAction(
                  Icons.favorite_border,
                  label: 'Like song',
                  onPressed: () {
                    state.favorite(Catalog.releases.last);
                    go(context, AppRoute.tasteResult);
                  },
                ),
              ],
            ),
            const SizedBox(height: 65),
            GradientButton(
              'FINISH',
              onPressed: () => go(context, AppRoute.tasteResult),
            ),
          ],
        ],
      ),
    );
  }
}

class AuraScreen extends StatefulWidget {
  const AuraScreen({super.key, this.conversation = false});
  final bool conversation;
  @override
  State<AuraScreen> createState() => _AuraScreenState();
}

class _AuraScreenState extends State<AuraScreen> {
  final _message = TextEditingController();
  bool replied = false;
  String query = '';
  @override
  void initState() {
    super.initState();
    replied = widget.conversation;
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  void send() {
    if (_message.text.trim().isEmpty) return;
    setState(() {
      query = _message.text.trim();
      replied = true;
      _message.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Aura',
      miniPlayer: false,
      scroll: false,
      action: IconButton(
        tooltip: 'Close Aura',
        onPressed: () => goHome(context),
        icon: const Icon(Icons.close),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuraLogo(size: 54),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Hello, ${state.name}.\nHere are songs for you now.',
                      style: const TextStyle(height: 1.7),
                    ),
                  ),
                  const SizedBox(height: 35),
                  const ReleaseStrip(),
                  const SizedBox(height: 20),
                  Text(
                    'Your offline music guide',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.aura.secondary,
                    ),
                  ),
                  if (replied) ...[
                    const SizedBox(height: 22),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: context.aura.gradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          query.isEmpty ? 'Find my favorite song!' : query,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text('I think this will give you pleasure'),
                    TrackTile(
                      Catalog.search(query).firstOrNull ?? Catalog.current,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _message,
                  decoration: const InputDecoration(
                    hintText: 'Ask me for a song or artist',
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (_) => send(),
                ),
              ),
              IconButton(
                tooltip: 'Send to Aura',
                onPressed: send,
                icon: const Icon(Icons.arrow_upward, color: AuraColors.cyan),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Profile',
      root: true,
      padding: EdgeInsets.zero,
      action: IconButton(
        tooltip: 'Edit profile',
        onPressed: () => _edit(context),
        icon: const Icon(Icons.edit_outlined),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Art(
                'avatar',
                width: double.infinity,
                height: 250,
                radius: 0,
              ),
              Container(
                height: 250,
                color: Colors.black.withValues(alpha: .45),
              ),
              Column(
                children: [
                  const Art('portrait', width: 90, height: 90, radius: 45),
                  const SizedBox(height: 20),
                  Text(
                    state.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Text(
                    state.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Music subscription'),
                Text(
                  'Listen to music in high quality even without the Internet and get additional features of our service.',
                  style: TextStyle(color: context.aura.secondary),
                ),
                const SizedBox(height: 30),
                GradientButton(
                  'EXPLORE MEMBERSHIP',
                  onPressed: () => go(context, AppRoute.subscription),
                ),
                const SizedBox(height: 25),
                Center(
                  child: TextButton(
                    onPressed: () => _gift(context),
                    child: const Text('ENTER GIFT CODE'),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => notice(
                      context,
                      'There are no online purchases on this local profile.',
                    ),
                    child: const Text('RESTORE PURCHASES'),
                  ),
                ),
                const Divider(height: 40),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.confirmation_number_outlined),
                  title: const Text('My tickets'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => go(context, AppRoute.ticket),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context) {
    final state = MusicScope.of(context);
    final name = TextEditingController(text: state.name),
        email = TextEditingController(text: state.email);
    final form = GlobalKey<FormState>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.trim().length < 2 ? 'Enter your name' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v == null ||
                        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(v.trim())
                    ? 'Enter a valid email'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!form.currentState!.validate()) return;
              await state.updateProfile(name.text, email.text);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      name.dispose();
      email.dispose();
    });
  }

  void _gift(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Gift code'),
      content: const Text(
        'Gift codes will be available when the music service is connected. You can explore every demo screen now.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: '',
    miniPlayer: false,
    action: IconButton(
      tooltip: 'Close membership',
      onPressed: () => goHome(context),
      icon: const Icon(Icons.close),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuraLogo(size: 45),
        const SizedBox(height: 55),
        Text(
          '90 days free with\nsubscription',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 35),
        for (final feature in [
          (Icons.play_circle_outline, 'Listen to any tracks'),
          (Icons.cloud_download_outlined, 'Without the Internet'),
          (Icons.volume_up_outlined, 'High quality'),
          (Icons.block, 'Without advertising'),
        ])
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(feature.$1, color: AuraColors.cyan),
            title: Text(feature.$2),
          ),
        const SizedBox(height: 45),
        GradientButton('EXPLORE THE DEMO', onPressed: () => goHome(context)),
        const SizedBox(height: 15),
        Center(
          child: Text(
            'Membership concept · no charge or subscription',
            style: TextStyle(color: context.aura.secondary, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}
