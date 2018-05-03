#include "ergodox_ez.h"
#include "debug.h"
#include "action_layer.h"
#include "version.h"

enum custom_layers {
  _COLEMAK,
  _NAV_MACROS,
  _NUMBERS,
  _SYMBOLS,
  _QWERTY
};

enum custom_keycodes {
  PLACEHOLDER = SAFE_RANGE,
  EPRM,
  VRSN,
  RGB_SLD,

  MC_ARROW,
  MC_HASH_ROCKET
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_COLEMAK] = KEYMAP(
      // Left hand
      KC_GRAVE,            KC_1,       KC_2,             KC_3,          KC_4,     KC_5,           KC_PGUP,
      KC_TAB,              KC_Q,       KC_W,             KC_F,          KC_P,     KC_G,           KC_LBRACKET,
      LT(_NUMBERS,         KC_BSPACE), KC_A,             KC_R,          KC_S,     KC_T,           KC_D,
      MO(_SYMBOLS),        KC_Z,       KC_X,             KC_C,          KC_V,     KC_B,           KC_MINUS,
      KC_UP,               KC_DOWN,    KC_TRNS,          KC_LALT,       KC_LSPO,

      // Left thumb
      KC_TRNS,             KC_TRNS,
      TG(_QWERTY),
      MT(MOD_LGUI,         KC_ENTER),  CTL_T(KC_ESCAPE), LSFT(KC_LGUI),

      // Right hand
      KC_PGDOWN,           KC_6,       KC_7,             KC_8,          KC_9,     KC_0,           KC_BSLASH,
      KC_RBRACKET,         KC_J,       KC_L,             KC_U,          KC_Y,     KC_SCOLON,      KC_QUOTE,
      KC_H,                KC_N,       KC_E,             KC_I,          KC_O,     LT(_NAV_MACROS, KC_BSPACE),
      KC_EQUAL,            KC_K,       KC_M,             KC_COMMA,      KC_DOT,   KC_SLASH,       LCTL(KC_A),
      KC_RSPC,             KC_HYPR,    KC_LGUI,          KC_LEFT,       KC_RIGHT,

      // Right thumb
      KC_MEDIA_PLAY_PAUSE, KC_ESCAPE,
      KC_TRNS,
      LCTL(KC_LGUI),       KC_BSPACE,  KC_SPACE
  ),

  [_NAV_MACROS] = KEYMAP(
      // Left hand
      KC_TRNS,  KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,        KC_TRNS, KC_TRNS,
      KC_TRNS,  KC_TRNS,        LALT(KC_B),         KC_UP,        LALT(KC_F),     KC_TRNS, KC_TRNS,
      RESET,    KC_TRNS,        KC_LEFT,            KC_DOWN,      KC_RIGHT,       KC_TRNS,
      KC_TRNS,  KC_TRNS,        LGUI(KC_LEFT),      KC_TRNS,      LGUI(KC_RIGHT), KC_TRNS, KC_TRNS,
      KC_TRNS,  KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,

      // Left thumb
      RGB_MOD,  KC_TRNS,
      RGB_VAI,
      KC_TRNS,  KC_TRNS,        RGB_VAD,

      // Right hand
      KC_TRNS,  KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,        KC_TRNS, KC_TRNS,
      KC_TRNS,  MC_HASH_ROCKET, LCTL(LSFT(KC_TAB)), LCTL(KC_TAB), KC_TRNS,        KC_TRNS, KC_TRNS,
      MC_ARROW, KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,        KC_TRNS,
      KC_TRNS,  KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,        KC_TRNS, KC_TRNS,
      KC_TRNS,  KC_TRNS,        KC_TRNS,            KC_TRNS,      KC_TRNS,

      // Right thumb
      RGB_TOG,  RGB_SLD,
      RGB_HUI,
      RGB_HUD,  KC_TRNS,        KC_TRNS
  ),

  [_NUMBERS] = KEYMAP(
      // Left hand
      KC_TRNS,        KC_F1,       KC_F2,   KC_F3,   KC_F4,   KC_F5,    KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS, KC_TRNS,

      // Left thumb
      KC_TRNS,        KC_TRNS,
      KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS,

      // Right hand
      KC_TRNS,        KC_F6,       KC_F7,   KC_F8,   KC_F9,   KC_F10,   KC_F11,
      KC_KP_PLUS,     KC_KP_MINUS, KC_7,    KC_8,    KC_KP_9, KC_TRNS,  KC_F12,
      KC_KP_ASTERISK, KC_4,        KC_5,    KC_6,    KC_DOT,  KC_EQUAL,
      KC_TRNS,        KC_KP_SLASH, KC_1,    KC_2,    KC_3,    KC_TRNS,  KC_TRNS,
      KC_KP_0,        KC_TRNS,     KC_TRNS, KC_TRNS, KC_TRNS,

      // Right thumb
      KC_TRNS,        KC_TRNS,
      KC_TRNS,
      KC_TRNS,        KC_TRNS,     KC_TRNS
  ),

  [_SYMBOLS] = KEYMAP(
      // Left hand
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS,

      // Left thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,

      // Right hand
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_AMPERSAND, KC_ASTERISK,   KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_DOLLAR, KC_PERCENT,   KC_CIRCUMFLEX, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_EXCLAIM,   KC_AT,         KC_HASH, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS,      KC_TRNS,       KC_TRNS,

      // Right thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS,   KC_TRNS
  ),

  [_QWERTY] = KEYMAP(
      // Left hand
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,   KC_TRNS,  KC_TRNS,
      KC_TRNS, KC_Q,    KC_W,    KC_E,     KC_R,      KC_T,     KC_TRNS,
      KC_TRNS, KC_A,    KC_S,    KC_D,     KC_F,      KC_G,
      KC_TRNS, KC_Z,    KC_X,    KC_C,     KC_V,      KC_B,     KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,

      // Left thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,

      // Right hand
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,   KC_TRNS,  KC_TRNS,
      KC_TRNS, KC_Y,    KC_U,    KC_I,     KC_O,      KC_P,     KC_TRNS,
      KC_H,    KC_J,    KC_K,    KC_L,     KC_SCOLON, KC_TRNS,
      KC_TRNS, KC_N,    KC_M,    KC_COMMA, KC_DOT,    KC_SLASH, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,  KC_TRNS,

      // Right thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS
  )
};

const uint16_t PROGMEM fn_actions[] = {
  [1] = ACTION_LAYER_TAP_TOGGLE(1)
};

void matrix_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
  rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case EPRM:
      if (record->event.pressed) {
        eeconfig_init();
      }
      return false;
      break;
    case VRSN:
      if (record->event.pressed) {
        SEND_STRING(QMK_KEYBOARD "/" QMK_KEYMAP " @ " QMK_VERSION);
      }
      return false;
      break;
    case RGB_SLD:
      if (record->event.pressed) {
        rgblight_mode(1);
      }
      return false;
      break;
    case MC_ARROW:
      if (record->event.pressed) {
        SEND_STRING("->");
      }
      return false;
      break;
    case MC_HASH_ROCKET:
      if (record->event.pressed) {
        SEND_STRING("=>");
      }
      return false;
      break;
  }

  return true;
}

uint32_t layer_state_set_user(uint32_t state) {
    uint8_t layer = biton32(state);

    ergodox_board_led_off();
    ergodox_right_led_1_off();
    ergodox_right_led_2_off();
    ergodox_right_led_3_off();
    switch (layer) {
      case 0:
        #ifdef RGBLIGHT_COLOR_LAYER_0
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
        #endif
        break;
      case 1:
        ergodox_right_led_1_on();
        #ifdef RGBLIGHT_COLOR_LAYER_1
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_1);
        #endif
        break;
      case 2:
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_2
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_2);
        #endif
        break;
      case 3:
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_3
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_3);
        #endif
        break;
      case 4:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_4
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_4);
        #endif
        break;
      case 5:
        ergodox_right_led_1_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_5
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_5);
        #endif
        break;
      case 6:
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_6
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_6);
        #endif
        break;
      case 7:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_7
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_6);
        #endif
        break;
      default:
        break;
    }
    return state;
};
