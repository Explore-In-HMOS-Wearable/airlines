export namespace Theme {
  export namespace Colors {
    export function primary(): Resource {
      return $r('app.color.primary');
    }

    export function onPrimary(): Resource {
      return $r('app.color.on_primary');
    }

    export function secondary(): Resource {
      return $r('app.color.secondary');
    }

    export function onSecondary(): Resource {
      return $r('app.color.on_secondary');
    }

    export function tertiary(): Resource {
      return $r('app.color.tertiary');
    }

    export function onTertiary(): Resource {
      return $r('app.color.on_tertiary');
    }

    export function background(): Resource {
      return $r('app.color.background');
    }

    export function onBackground(): Resource {
      return $r('app.color.on_background');
    }

    export function surface(): Resource {
      return $r('app.color.surface');
    }

    export function onSurface(): Resource {
      return $r('app.color.on_surface');
    }

    export function surfaceVariant(): Resource {
      return $r('app.color.surface_variant');
    }

    export function outline(): Resource {
      return $r('app.color.outline');
    }

    export function divider(): Resource {
      return $r('app.color.divider');
    }

    export function textPrimary(): Resource {
      return $r('app.color.text_primary');
    }

    export function textSecondary(): Resource {
      return $r('app.color.text_secondary');
    }

    export function textDisabled(): Resource {
      return $r('app.color.text_disabled');
    }

    export function textInverse(): Resource {
      return $r('app.color.text_inverse');
    }

    export function success(): Resource {
      return $r('app.color.success');
    }

    export function onSuccess(): Resource {
      return $r('app.color.on_success');
    }

    export function warning(): Resource {
      return $r('app.color.warning');
    }

    export function onWarning(): Resource {
      return $r('app.color.on_warning');
    }

    export function error(): Resource {
      return $r('app.color.error');
    }

    export function onError(): Resource {
      return $r('app.color.on_error');
    }

    export function info(): Resource {
      return $r('app.color.info');
    }

    export function onInfo(): Resource {
      return $r('app.color.on_info');
    }

    export function disabled(): Resource {
      return $r('app.color.disabled');
    }

    export function boarding(): Resource {
      return $r('app.color.boarding');
    }

    export function departed(): Resource {
      return $r('app.color.departed');
    }

    export function arrived(): Resource {
      return $r('app.color.arrived');
    }
  }

  export namespace FontSize {
    export const xs = 10;

    export const small = 12;

    export const medium = 14;

    export const large = 16;

    export const xlarge = 20;

    export const xxlarge = 24;

    export const title = 28;

    export const huge = 32;
  }

  export namespace Weight {
    export const regular = FontWeight.Regular;

    export const medium = FontWeight.Medium;

    export const bold = FontWeight.Bold;
  }

  export namespace FontFamily {
    export const defaultFont = 'HarmonyOS Sans';
  }

  export namespace Padding {
    export const xs = 6;

    export const small = 10;

    export const medium = 14;

    export const large = 18;

    export const xlarge = 24;

    export function horizontal(value: number): Padding {
      return { left: value, right: value };
    }

    export function vertical(value: number): Padding {
      return { top: value, bottom: value };
    }

    export function all(value: number): Padding {
      return {
        left: value,
        right: value,
        top: value,
        bottom: value
      };
    }

    export function only(p: Padding): Padding {
      return p;
    }
  }

  export namespace Margin {
    export const xs = 4;

    export const small = 8;

    export const medium = 12;

    export const large = 16;

    export const xlarge = 24;

    export function horizontal(value: number): Margin {
      return { left: value, right: value };
    }

    export function vertical(value: number): Margin {
      return { top: value, bottom: value };
    }

    export function all(value: number): Margin {
      return {
        left: value,
        right: value,
        top: value,
        bottom: value
      };
    }

    export function only(m: Margin): Margin {
      return m;
    }
  }

  export namespace Radius {
    export const small = 6;

    export const medium = 10;

    export const large = 16;

    export const xlarge = 24;

    export const pill = 999;
  }
}