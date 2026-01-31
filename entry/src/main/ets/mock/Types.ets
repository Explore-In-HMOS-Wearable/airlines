export type FlightStatus = 'On Time' | 'Delayed' | 'Boarding' | 'Departed' | 'Arrived' | 'Cancelled';

export interface Flight {
  id: number;
  origin: string;
  destination: string;
  status: FlightStatus;
  departureDate: string;
  arrivalDate: string;
  flightNumber: string;
  price: number;
}

export interface FlightTicket {
  flightId: number;
  price: number;
  seat?: string;
  gate?: string;
  qrCode?: string;
}

export interface FlightDetailParams {
  flightId: number;
}