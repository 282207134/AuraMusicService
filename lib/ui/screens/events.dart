import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';
import '../widgets/common.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Events',
    subtitle: 'Moscow, Russia',
    root: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => go(context, AppRoute.event),
          child: const _EventCard(),
        ),
        SectionTitle(
          'Concert halls',
          onSeeAll: () =>
              notice(context, 'Showing all 4 venues in the demo catalog.'),
        ),
        for (final hall in [
          ('Kremlin palace', 'Concert hall', 'classic'),
          ('Olympic', 'Concert hall, sports complex', 'radio'),
          ('Otkritie Arena', 'Concert hall, stadium', 'rock'),
          ('Crocus City Hall', 'Concert halls', 'genres'),
        ])
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 9),
            leading: Disc(hall.$3, size: 60),
            title: Text(hall.$1, style: const TextStyle(fontSize: 21)),
            subtitle: Text(
              hall.$2,
              style: TextStyle(fontSize: 13, color: context.aura.secondary),
            ),
            onTap: () => go(context, AppRoute.event),
          ),
        const SectionTitle('Concerts of popular music'),
        InkWell(
          onTap: () => go(context, AppRoute.event),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Art('artist', width: double.infinity, height: 175),
              const SizedBox(height: 16),
              const Text(
                'A night of alternative rock',
                style: TextStyle(fontSize: 21),
              ),
              Text(
                'Moscow, Olympic · August 29, 19:00',
                style: TextStyle(color: context.aura.secondary),
              ),
            ],
          ),
        ),
        const SectionTitle('In genres'),
        for (final genre in Catalog.genres.where(
          (g) => ['Rock', 'Rap', 'Classic'].contains(g.title),
        ))
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: InkWell(
              onTap: () => go(context, AppRoute.rock),
              child: Stack(
                children: [
                  Art(genre.art, width: double.infinity, height: 90),
                  Container(height: 90, color: Colors.black26),
                  Positioned(
                    left: 25,
                    top: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          genre.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                        const Text(
                          'Explore the music',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class _EventCard extends StatelessWidget {
  const _EventCard();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          const Art('event', width: double.infinity, height: 180),
          Positioned(
            left: 16,
            bottom: 16,
            child: Row(
              children: [
                for (final label in ['CONCERT', 'ROCK'])
                  Container(
                    margin: const EdgeInsets.only(right: 7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: Colors.white30,
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const Text('Imagine Dragons', style: TextStyle(fontSize: 23)),
      const SizedBox(height: 5),
      Text(
        'Moscow, big sports arena «Luzhniki»',
        style: TextStyle(color: context.aura.secondary),
      ),
      const SizedBox(height: 4),
      Text(
        'August 29, 19:00 · demo event',
        style: TextStyle(color: context.aura.secondary),
      ),
    ],
  );
}

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool more = false;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Imagine Dragons',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _EventCard(),
        const SizedBox(height: 30),
        GradientButton(
          'BUY DEMO TICKETS',
          onPressed: () => go(context, AppRoute.venue),
        ),
        const SectionTitle('About the concert'),
        const Text(
          'An evening of music, energy and a crowd singing as one. Choose your zone and find your place at Luzhniki.',
        ),
        if (more)
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Text(
              'Doors open at 18:00. The show starts at 19:00. This event is part of the design demonstration; tickets have no admission value.',
            ),
          ),
        TextButton(
          onPressed: () => setState(() => more = !more),
          child: Text(
            more ? 'READ LESS' : 'READ MORE',
            style: const TextStyle(fontSize: 11),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            for (final art in ['band', 'artist', 'event'])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Art(art, height: 80),
                ),
              ),
          ],
        ),
        const SectionTitle('Best tracks'),
        for (final track in Catalog.chart.take(3)) TrackTile(track),
      ],
    ),
  );
}

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key, this.seats = false});
  final bool seats;
  @override
  State<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  double zoom = 1;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Imagine Dragons',
      miniPlayer: false,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < 5; i++)
                Column(
                  children: [
                    Container(
                      width: 48,
                      height: 3,
                      color: [
                        AuraColors.blue,
                        AuraColors.cyan,
                        Colors.orange,
                        AuraColors.pink,
                        Colors.purple,
                      ][i],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ['\$ 80+', '\$ 100+', '\$ 120+', '\$ 220+', '\$ 250+'][i],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            widget.seats ? 'Dance orchestra' : 'Choose your zone',
            style: TextStyle(color: context.aura.secondary),
          ),
          const SizedBox(height: 12),
          if (widget.seats) ...[
            Text(
              'STAGE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 3,
                color: context.aura.secondary,
              ),
            ),
            const Divider(height: 25),
            InteractiveViewer(
              minScale: 1,
              maxScale: 2,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 120,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, i) {
                  final unavailable = i < 20 || i % 19 == 0;
                  final selected = state.selectedSeats.contains(i);
                  return Semantics(
                    label:
                        'Seat ${i + 1}${unavailable
                            ? ', unavailable'
                            : selected
                            ? ', selected'
                            : ', available'}',
                    button: !unavailable,
                    child: InkWell(
                      key: Key('seat-$i'),
                      onTap: unavailable ? null : () => state.selectSeat(i),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: unavailable
                              ? context.aura.secondary.withValues(alpha: .35)
                              : selected
                              ? AuraColors.cyan
                              : AuraColors.pink,
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Pink: available   •   Teal: selected   •   Gray: unavailable',
              style: TextStyle(fontSize: 10, color: context.aura.secondary),
            ),
          ] else ...[
            SizedBox(
              height: 365,
              child: InteractiveViewer(
                minScale: .8,
                maxScale: 3,
                child: Transform.scale(
                  scale: zoom,
                  child: GestureDetector(
                    onTap: () => go(context, AppRoute.seats),
                    child: CustomPaint(
                      size: const Size(325, 365),
                      painter: _VenuePainter(
                        context.aura.foreground,
                        context.aura.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Zoom out',
                  onPressed: () =>
                      setState(() => zoom = (zoom - .1).clamp(.8, 1.5)),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  tooltip: 'Zoom in',
                  onPressed: () =>
                      setState(() => zoom = (zoom + .1).clamp(.8, 1.5)),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
          const SizedBox(height: 25),
          GradientButton(
            widget.seats
                ? state.selectedSeats.isEmpty
                      ? 'SELECT YOUR SEATS'
                      : 'Buy ${state.selectedSeats.length} tickets for \$ ${state.ticketTotal}'
                : 'CHOOSE SEATS · DANCE ORCHESTRA',
            onPressed: widget.seats && state.selectedSeats.isEmpty
                ? null
                : () => go(
                    context,
                    widget.seats ? AppRoute.payment : AppRoute.seats,
                  ),
          ),
          const SizedBox(height: 15),
          Text(
            'Demo booking · no real event or payment',
            style: TextStyle(color: context.aura.secondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _VenuePainter extends CustomPainter {
  _VenuePainter(this.foreground, this.muted);
  final Color foreground, muted;
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AuraColors.blue,
      AuraColors.cyan,
      const Color(0xffedb897),
      AuraColors.pink,
      const Color(0xffad6aa5),
    ];
    for (var ring = 0; ring < 5; ring++) {
      for (var block = 0; block < 18; block++) {
        final rect = Rect.fromCenter(
          center: Offset(size.width / 2, size.height * .42),
          width: size.width * .92 - ring * 24,
          height: size.height * .76 - ring * 24,
        );
        canvas.drawArc(
          rect,
          block * math.pi / 18,
          math.pi / 18 - .025,
          false,
          Paint()
            ..color = colors[ring]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10,
        );
      }
    }
    final center = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .23, 78, size.width * .54, 160),
      const Radius.circular(6),
    );
    canvas.drawRRect(center, Paint()..color = AuraColors.pink);
    canvas.drawRect(
      Rect.fromLTWH(size.width * .23, 50, size.width * .54, 48),
      Paint()..color = const Color(0xffac6aa5),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * .25, 42, size.width * .5, 5),
      Paint()..color = foreground,
    );
    void label(String text, double y, Color color) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: color, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset((size.width - painter.width) / 2, y));
    }

    label('STAGE', 18, muted);
    label('Radioactive zone', 67, Colors.white);
    label('Dance orchestra', 160, Colors.white);
  }

  @override
  bool shouldRepaint(_VenuePainter oldDelegate) =>
      oldDelegate.foreground != foreground || oldDelegate.muted != muted;
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  String method = 'Card';
  bool busy = false;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Payment',
      miniPlayer: false,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                for (final label in ['Card', 'PayPal', 'Apple Pay'])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        selected: method == label,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => method = label),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuraColors.cyan.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Demo checkout. No money is charged.\nUse the sample payment details below.',
                style: TextStyle(fontSize: 12, color: context.aura.secondary),
              ),
            ),
            const SizedBox(height: 25),
            if (method == 'Card') ...[
              const TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Demo card number',
                  hintText: '4242 4242 4242 4242',
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Month / Year',
                        hintText: '12 / 30',
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Demo CVV',
                        hintText: '123',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '$method sandbox preview',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            TextFormField(
              key: const Key('ticket-name'),
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Ticket holder name',
              ),
              validator: (value) => (value?.trim().length ?? 0) < 2
                  ? 'Enter a ticket holder name'
                  : null,
            ),
            const SizedBox(height: 28),
            Text(
              '${state.selectedSeats.length} tickets · Dance orchestra',
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              'Total \$ ${state.ticketTotal}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 30),
            GradientButton(
              busy ? 'CONFIRMING…' : 'CONFIRM DEMO BOOKING',
              onPressed: busy || state.selectedSeats.isEmpty
                  ? null
                  : () async {
                      if (!_form.currentState!.validate()) return;
                      setState(() => busy = true);
                      await state.purchaseTicket(_name.text);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoute.ticket.path,
                        );
                      }
                    },
            ),
            if (state.selectedSeats.isEmpty)
              TextButton(
                onPressed: () => go(context, AppRoute.seats),
                child: const Text('Choose seats first'),
              ),
          ],
        ),
      ),
    );
  }
}

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    if (!state.ticketPurchased) {
      return PageFrame(
        title: 'Your ticket',
        miniPlayer: false,
        child: Column(
          children: [
            const SizedBox(height: 90),
            const Icon(
              Icons.confirmation_number_outlined,
              size: 75,
              color: AuraColors.cyan,
            ),
            const SizedBox(height: 30),
            const Text(
              'Your next great night starts here.',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            GradientButton(
              'EXPLORE EVENTS',
              onPressed: () => go(context, AppRoute.events),
            ),
          ],
        ),
      );
    }
    final seats = state.bookedSeats.map((i) => '${i + 1}').join(', ');
    return PageFrame(
      title: 'Your ticket',
      miniPlayer: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _EventCard(),
          const SizedBox(height: 30),
          Text(
            '${state.bookedSeats.length} tickets in dance orchestra',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 7),
          Text(
            '${state.ticketHolder} · Seats $seats',
            style: TextStyle(color: context.aura.secondary),
          ),
          const SizedBox(height: 5),
          Text(
            'Price total \$ ${(state.bookedSeats.length * 220)}',
            style: TextStyle(color: context.aura.secondary),
          ),
          const SizedBox(height: 35),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarcodePainter(context.aura.foreground),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'AURA DEMO 124775',
              style: TextStyle(fontSize: 10, letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 30),
          GradientButton(
            state.ticketSaved ? 'SAVED TO MY TICKETS' : 'SAVE TO MY TICKETS',
            icon: state.ticketSaved ? Icons.check : null,
            onPressed: () async {
              await state.saveTicket();
              if (context.mounted) {
                notice(
                  context,
                  'Saved on this device. Open Profile → My tickets.',
                );
              }
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        'Aura demo ticket · Imagine Dragons · Seats $seats · Total \$ ${(state.bookedSeats.length * 220)} · Not valid for admission',
                  ),
                );
                if (context.mounted) notice(context, 'Ticket summary copied.');
              },
              icon: const Icon(Icons.share_outlined, size: 19),
              label: const Text('COPY TICKET SUMMARY'),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'DEMONSTRATION · NOT VALID FOR ADMISSION',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: .6,
                color: context.aura.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  const _BarcodePainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 100; i++) {
      final x = i * size.width / 100;
      canvas.drawRect(
        Rect.fromLTWH(x, 0, i % 3 == 0 ? 2 : 1, size.height),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_BarcodePainter oldDelegate) => oldDelegate.color != color;
}
