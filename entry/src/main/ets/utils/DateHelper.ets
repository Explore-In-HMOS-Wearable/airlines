export class DateHelper {
  private static parse(dateStr: string): Date {
    return new Date(dateStr);
  }

  private static formatHHmm(date: Date): string {
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
  }

  static formatTime(dateStr: string): string {
    const date = DateHelper.parse(dateStr);
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
  }

  static formatDate(dateStr: string): string {
    const date = DateHelper.parse(dateStr);
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return `${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}`;
  }

  static getDayName(dateStr: string): string {
    const date = DateHelper.parse(dateStr);
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[date.getDay()];
  }

  static formatTimeWithOffset(dateStr: string, offsetMinutes: number): string {
    const date = DateHelper.parse(dateStr);
    date.setMinutes(date.getMinutes() + offsetMinutes);
    return DateHelper.formatHHmm(date);
  }

  static getBoardingTime(dateStr: string): string {
    return DateHelper.formatTimeWithOffset(dateStr, -30);
  }
}
