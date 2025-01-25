class TicketInfo {
  final String date;
  final String time;
  final String seat;
  final String country;
  final String city;
  final String stadium;
  final String ticketId;

  TicketInfo({
    required this.date,
    required this.time,
    required this.seat,
    required this.country,
    required this.city,
    required this.stadium,
    required this.ticketId,
  });
}


final List<TicketInfo> tickets = [
      TicketInfo(
        date: "2025-01-25",
        time: "14:00",
        seat: "A12",
        country: "Thailand",
        city: "Bangkok",
        stadium: "Rajamangala Stadium",
        ticketId: "TICK1234",
      ),
      TicketInfo(
        date: "2025-02-10",
        time: "18:00",
        seat: "B5",
        country: "Japan",
        city: "Tokyo",
        stadium: "Tokyo Dome",
        ticketId: "TICK5678",
      ),
      TicketInfo(
        date: "2025-03-05",
        time: "20:00",
        seat: "C20",
        country: "USA",
        city: "New York",
        stadium: "Yankee Stadium",
        ticketId: "TICK9012",
      ),
      TicketInfo(
        date: "2025-04-15",
        time: "15:30",
        seat: "D7",
        country: "France",
        city: "Paris",
        stadium: "Parc des Princes",
        ticketId: "TICK3456",
      ),
    ];