import { Flight, FlightTicket } from './Types';

const mockFlights: Flight[] = [
  {
    id: 1,
    origin: 'IST',
    destination: 'LHR',
    status: 'On Time',
    departureDate: '2026-01-20T08:30:00',
    arrivalDate: '2026-01-20T11:15:00',
    flightNumber: 'TK1984',
    price: 350
  },
  {
    id: 2,
    origin: 'IST',
    destination: 'CDG',
    status: 'Delayed',
    departureDate: '2026-01-20T10:45:00',
    arrivalDate: '2026-01-20T13:20:00',
    flightNumber: 'TK1823',
    price: 320
  },
  {
    id: 3,
    origin: 'IST',
    destination: 'FRA',
    status: 'On Time',
    departureDate: '2026-01-20T12:00:00',
    arrivalDate: '2026-01-20T14:30:00',
    flightNumber: 'TK1601',
    price: 290
  },
  {
    id: 4,
    origin: 'IST',
    destination: 'JFK',
    status: 'On Time',
    departureDate: '2026-01-21T16:00:00',
    arrivalDate: '2026-01-21T20:30:00',
    flightNumber: 'TK0001',
    price: 850
  }
];

const mockFlightTickets: FlightTicket[] = [
  {
    flightId: 1,
    price: 350,
    seat: '12A',
    gate: 'A3',
    qrCode: 'TK1984-IST-LHR-20260120-12A'
  },
  {
    flightId: 2,
    price: 320,
    seat: '15C',
    gate: 'B2',
    qrCode: 'TK1823-IST-CDG-20260120-15C'
  },
  {
    flightId: 3,
    price: 290,
    seat: '08F',
    gate: 'C1',
    qrCode: 'TK1601-IST-FRA-20260120-08F'
  },
  {
    flightId: 4,
    price: 850
  }
];

export function getFlights(): Flight[] {
  return mockFlights;
}

export function getFlight(id: number): Flight | null {
  return mockFlights.find(f => f.id === id) ?? null;
}

export function getFlightTicket(flightId: number): FlightTicket | undefined {
  return mockFlightTickets.find(t => t.flightId === flightId);
}