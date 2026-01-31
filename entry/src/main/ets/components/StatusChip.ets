import { FlightStatus } from '../mock/Types';

@Component
export struct StatusChip {
  @Prop status: FlightStatus;

  private getStatusColor(): ResourceColor {
    switch (this.status) {
      case 'On Time':
        return '#34C759';
      case 'Boarding':
        return '#007AFF';
      case 'Delayed':
        return '#FF9500';
      case 'Departed':
        return '#5AC8FA';
      case 'Arrived':
        return '#34C759';
      case 'Cancelled':
        return '#FF3B30';
      default:
        return '#8E8E93';
    }
  }

  build() {
    Text(this.status)
      .fontSize(13)
      .fontColor(this.getStatusColor())
      .fontWeight(FontWeight.Medium);
  }
}
