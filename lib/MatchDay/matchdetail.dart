import 'package:flutter/material.dart';
import 'ticket_booking.dart';

class MatchDetail extends StatefulWidget {
  final String matchId;
  final String title;
  final String leagueName;
  final String matchDate;
  final String matchTime;
  final String stadiumName;
  final String description;
  final int zoneAprice;
  final int zoneBprice;
  final int zoneCprice;
  final int zoneDprice;
  final int zoneAseate;
  final int zoneBseate;
  final int zoneCseate;
  final int zoneDseate;
  


  const MatchDetail({
    super.key,
    required this.matchId,
    required this.title,
    required this.leagueName,
    required this.matchDate,
    required this.matchTime,
    required this.stadiumName,
    required this.description,
    required this.zoneAprice,
    required this.zoneBprice,
    required this.zoneCprice,
    required this.zoneDprice,
    required this.zoneAseate,
    required this.zoneBseate,
    required this.zoneCseate,
    required this.zoneDseate,
  });

  @override
  _MatchDetailState createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Match Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Stadium Image Card
          const StadiumCard(),

          // Match Title Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Match ID: ${widget.matchId}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Match Info Card
          MatchInfoCard(
            leagueName: widget.leagueName,
            matchDate: widget.matchDate,
            matchTime: widget.matchTime,
            stadiumName: widget.stadiumName,
            description: widget.description,
          ),

          // Zone Cards
          ZoneCard(
            zone: "North Zone A",
            price: widget.zoneAprice,
            seatleft : widget.zoneAseate,            
            onTap: () => _navigateToBooking("A", 1000),
          ),
          ZoneCard(
            zone: "South Zone B",
            seatleft : widget.zoneBseate,            
            price: widget.zoneBprice,            
            onTap: () => _navigateToBooking("B", 800),
          ),
          ZoneCard(
            zone: "West Zone C",
            seatleft : widget.zoneCseate,            
            price: widget.zoneCprice,            
            onTap: () => _navigateToBooking("C", 600),
          ),
          ZoneCard(
            zone: "East Zone D",
            seatleft : widget.zoneDseate,            
            price: widget.zoneDprice,            
            onTap: () => _navigateToBooking("D", 500),
          ),
        ],
      ),
    );
  }

  void _navigateToBooking(String zone, int price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketBooking(
          matchId: widget.matchId,
          title: widget.title,
          zone: zone,
          price: price,
          matchDate: widget.matchDate,
          matchTime: widget.matchTime,
          stadiumName: widget.stadiumName,
          leagueName: widget.leagueName,
          description: widget.description,
        ),
      ),
    );
  }
}


class StadiumCard extends StatelessWidget {
  const StadiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      height: 360,
      width: (MediaQuery.of(context).size.width) - 30,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/staduim/S2.png'),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}

class MatchInfoCard extends StatelessWidget {
  final String leagueName;
  final String matchDate;
  final String matchTime;
  final String stadiumName;
  final String description;

  const MatchInfoCard({
    super.key,
    required this.leagueName,
    required this.matchDate,
    required this.matchTime,
    required this.stadiumName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_soccer, size: 30, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 10),
              Text(
                leagueName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.calendar_today, 'Date: $matchDate'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.access_time, 'Time: $matchTime'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.stadium, 'Stadium: $stadiumName'),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class ZoneCard extends StatelessWidget {
  final String zone;
  final int price;
  final VoidCallback onTap;
  final int seatleft ;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.price,
    required this.onTap,
    required this.seatleft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chair, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '฿$price',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'seats left $seatleft',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(221, 110, 110, 110),
                          
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
