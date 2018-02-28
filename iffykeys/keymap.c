#include "ergodox_ez.h"
#include "debug.h"
#include "action_layer.h"
#include "version.h"

enum custom_layers {
  _COLEMAK,
  _NAV,
  _PROGRAMMING,
  _SYMBOLS,
  _NUMBERS
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
      KC_GRAVE,            KC_1,         KC_2,             KC_3,          KC_4,      KC_5,      KC_PGUP,
      KC_TAB,              KC_Q,         KC_W,             KC_F,          KC_P,      KC_B,      LCTL(KC_A),
      MO(2),               KC_A,         KC_R,             KC_S,          KC_T,      KC_G,
      MO(4),               KC_Z,         KC_X,             KC_C,          KC_D,      KC_V,      KC_MINUS,
      KC_UP,               KC_DOWN,      KC_TRNS,          KC_LALT,       KC_LSHIFT,

      // Left thumb
      LCTL(LSFT(KC_TAB)),  LCTL(KC_TAB),
      KC_TRNS,
      MT(MOD_LGUI,         KC_ENTER),    CTL_T(KC_ESCAPE), LSFT(KC_LGUI),

      // Right hand
      KC_PGDOWN,           KC_6,         KC_7,             KC_8,          KC_9,      KC_0,      KC_ESCAPE,
      KC_BSLASH,           KC_J,         KC_L,             KC_U,          KC_Y,      KC_SCOLON, KC_QUOTE,
      KC_M,                KC_N,         KC_E,             KC_I,          KC_O,      MO(1),
      KC_EQUAL,            KC_K,         KC_H,             KC_COMMA,      KC_DOT,    KC_SLASH,  MO(3),
      KC_RSHIFT,           KC_HYPR,      KC_TRNS,          KC_LEFT,       KC_RIGHT,

      // Right thumb
      KC_MEDIA_PLAY_PAUSE, KC_ESCAPE,
      KC_TRNS,
      LCTL(KC_LGUI),       KC_BSPACE,    KC_SPACE
  ),

  [_NAV] = KEYMAP(
      // Left hand
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, LALT(KC_B), KC_UP,   LALT(KC_F), KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_LEFT,    KC_DOWN, KC_RIGHT,   KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,

      // Left thumb
      RGB_MOD, KC_TRNS,
      RGB_VAI,
      KC_TRNS, KC_TRNS, RGB_VAD,

      // Right hand
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS,

      // Right thumb
      RGB_TOG, RGB_SLD,
      RGB_HUI,
      RGB_HUD, KC_TRNS, KC_TRNS
  ),

  [_PROGRAMMING] = KEYMAP(
      // Left hand
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,

      // Left thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,

      // Right hand
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS, RESET,
      KC_TRNS, KC_TRNS, KC_LCBR,     MC_HASH_ROCKET, KC_RCBR,     KC_TRNS, KC_TRNS,
      KC_COLN, KC_LPRN, MC_ARROW,    KC_RPRN,        KC_TRNS,     KC_TRNS,
      KC_TRNS, KC_TRNS, KC_LBRACKET, KC_TRNS,        KC_RBRACKET, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,     KC_TRNS,        KC_TRNS,

      // Right thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS
  ),

  [_SYMBOLS] = KEYMAP(
      // Left hand
      KC_TRNS, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_TRNS,
      KC_TRNS, KC_TRNS, KC_AMPR, KC_ASTR, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_DLR,  KC_PERC, KC_CIRC, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_EXLM, KC_AT,   KC_HASH, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,

      // Left thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS,

      // Right hand
      KC_TRNS, KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_F12,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,

      // Right thumb
      KC_TRNS, KC_TRNS,
      KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS
  ),

  [_NUMBERS] = KEYMAP(
      // Left hand
      KC_TRNS,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,        KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,        KC_TRNS,     KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,

      // Left thumb
      KC_TRNS,   KC_TRNS,
      KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS,

      // Right hand
      KC_TRNS,   KC_TRNS, KC_KP_PLUS, KC_KP_MINUS, KC_KP_ASTERISK, KC_KP_SLASH, KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_KP_7,    KC_KP_8,     KC_KP_9,        KC_TRNS,     KC_TRNS,
      KC_KP_DOT, KC_KP_4, KC_KP_5,    KC_KP_6,     KC_EQUAL,       KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_KP_1,    KC_KP_2,     KC_KP_3,        KC_TRNS,     KC_TRNS,
      KC_KP_0,   KC_TRNS, KC_TRNS,    KC_TRNS,     KC_TRNS,

      // Right thumb
      KC_TRNS,   KC_TRNS,
      KC_TRNS,
      KC_TRNS,   KC_TRNS, KC_TRNS
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
