import 'package:flutter/material.dart';
import 'payment.dart';

class TicketBooking extends StatefulWidget {
  final String zone;
  final int price;
  final String matchId;
  final String title;
  final String leagueName;
  final String matchDate;
  final String matchTime;
  final String stadiumName;
  final String description;

  const TicketBooking({
    Key? key,
    required this.zone,
    required this.price,
    required this.matchId,
    required this.title,
    required this.leagueName,
    required this.matchDate,
    required this.matchTime,
    required this.stadiumName,
    required this.description,
  }) : super(key: key);

  @override
  _TicketBookingState createState() => _TicketBookingState();
}


class _TicketBookingState extends State<TicketBooking> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Booking'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZoneInfoCard(zone: widget.zone, price: widget.price , matchId: widget.matchId, title: widget.title),
            const SizedBox(height: 30),
            QuantitySelector(
              quantity: quantity,
              onChanged: (value) => setState(() => quantity = value),
            ),
            const SizedBox(height: 20),
            TotalPriceCard(total: widget.price * quantity),
            const Spacer(),
            ConfirmBookingButton(
              onPressed: () => _showConfirmationDialog(context),
              zone: widget.zone,
              quantity: quantity,
              price: widget.price,

            ),
          ],
        ),
      ),
    );
  }

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BookingConfirmationDialog(
        matchId: widget.matchId,
        title: widget.title,
        zone: widget.zone,
        quantity: quantity,
        price: widget.price,
        matchDate: widget.matchDate,
        matchTime: widget.matchTime,
        stadiumName: widget.stadiumName,
        leagueName: widget.leagueName,
      );
    },
  );
}

}

// Widget แสดงข้อมูลโซนและราคา
class ZoneInfoCard extends StatelessWidget {
  final String zone;
  final int price;
  final String matchId;
  final String title;

  const ZoneInfoCard({
    Key? key,
    required this.zone,
    required this.price,
    required this.matchId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 217, 217, 217),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Match ID: $matchId',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          Text(
            'Zone Name: $zone',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          Text(
            'Price per ticket: ฿$price',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget เลือกจำนวนตั๋ว
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Quantity:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) {
                  onChanged(quantity - 1);
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                quantity.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(quantity + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

// Widget แสดงราคารวม
class TotalPriceCard extends StatelessWidget {
  final int total;

  const TotalPriceCard({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Price:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '฿$total',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ปุ่มยืนยันการจอง
class ConfirmBookingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String zone;
  final int quantity;
  final int price;

  const ConfirmBookingButton({
    Key? key,
    required this.onPressed,
    required this.zone,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Confirm Booking',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Widget Dialog ยืนยันการจอง
class BookingConfirmationDialog extends StatelessWidget {
  final String matchId;
  final String title;
  final String zone;
  final int quantity;
  final int price;
  final String matchDate;
  final String matchTime;
  final String stadiumName;
  final String leagueName;

  const BookingConfirmationDialog({
    Key? key,
    required this.matchId,
    required this.title,
    required this.zone,
    required this.quantity,
    required this.price,
    required this.matchDate,
    required this.matchTime,
    required this.stadiumName,
    required this.leagueName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: Colors.black,
            size: 28,
          ),
          SizedBox(width: 10),
          Text(
            'Confirm Booking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: BookingDetailsContent(
        matchId: matchId,
        title: title,
        zone: zone,
        quantity: quantity,
        price: price,
      ),
      actions: [
        DialogActions(
          matchId: matchId,
          title: title,
          zone: zone,
          quantity: quantity,
          price: price,
          matchDate: matchDate,
          matchTime: matchTime,
          stadiumName: stadiumName,
          leagueName: leagueName,
        ),
      ],
    );
  }
}


// Widget เนื้อหาใน Dialog
class BookingDetailsContent extends StatelessWidget {
  final String matchId;
  final String title;
  final String zone;
  final int quantity;
  final int price;

  const BookingDetailsContent({
    Key? key,
    required this.matchId,
    required this.title,
    required this.zone,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Match ID: $matchId',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 15),
          DetailRow(
            icon: Icons.location_on_outlined,
            text: 'Zone: $zone',
          ),
          const SizedBox(height: 8),
          DetailRow(
            icon: Icons.confirmation_number,
            text: 'Tickets: $quantity',
          ),
          const SizedBox(height: 8),
          DetailRow(
            icon: Icons.payments_outlined,
            text: 'Total: ฿${price * quantity}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isTotal;

  const DetailRow({
    Key? key,
    required this.icon,
    required this.text,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: isTotal ? 16 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}


class DialogActions extends StatelessWidget {
  final String matchId;
  final String title;
  final String zone;
  final int quantity;
  final int price;
  final String matchDate;
  final String matchTime;
  final String stadiumName;
  final String leagueName;

  const DialogActions({
    Key? key,
    required this.matchId,
    required this.title,
    required this.zone,
    required this.quantity,
    required this.price,
    required this.matchDate,
    required this.matchTime,
    required this.stadiumName,
    required this.leagueName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    matchId: matchId,
                    title: title,
                    zone: zone,
                    quantity: quantity,
                    totalPrice: price * quantity,
                    matchDate: matchDate,
                    matchTime: matchTime,
                    stadiumName: stadiumName,
                    leagueName: leagueName,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
