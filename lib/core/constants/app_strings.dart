/// App strings and text constants for MathMate calculator.
///
/// This class contains all the text displayed in the app.
/// Centralizing strings:
/// - Avoids typos from duplicated strings
/// - Makes localization easier in the future
/// - Provides a single source of truth for all text
///
/// Note: For a production app, you would use Flutter's intl package
/// for proper internationalization (i18n).
abstract class AppStrings {
  // ============================================================
  // APP INFO
  // ============================================================

  /// App name displayed in the app bar and about screen.
  static const String appName = 'MathMate';

  /// App version.
  static const String appVersion = '1.0.0';

  // ============================================================
  // BUTTON LABELS
  // ============================================================

  // Numbers
  static const String zero = '0';
  static const String one = '1';
  static const String two = '2';
  static const String three = '3';
  static const String four = '4';
  static const String five = '5';
  static const String six = '6';
  static const String seven = '7';
  static const String eight = '8';
  static const String nine = '9';

  // Operators (using proper Unicode symbols for display)
  static const String plus = '+';
  static const String minus = '−'; // Unicode minus sign (U+2212)
  static const String multiply = '×'; // Unicode multiplication sign (U+00D7)
  static const String divide = '÷'; // Unicode division sign (U+00F7)
  static const String equals = '=';

  // For internal calculations, use ASCII operators
  static const String plusCalc = '+';
  static const String minusCalc = '-';
  static const String multiplyCalc = '*';
  static const String divideCalc = '/';

  // Functions
  static const String clear = 'C';
  static const String allClear = 'AC';
  static const String backspace = '⌫'; // Unicode delete symbol (U+232B)
  static const String decimal = '.';
  static const String percent = '%';
  static const String plusMinus = '±';
  static const String openParen = '(';
  static const String closeParen = ')';
  static const String settings = '⚙'; // Unicode gear symbol (U+2699)
  static const String history = '🕐'; // Clock symbol for history

  // ============================================================
  // SETTINGS LABELS
  // ============================================================

  static const String settingsTitle = 'Settings';
  static const String themeMode = 'Theme';
  static const String themeModeLight = 'Light';
  static const String themeModeDark = 'Dark';
  static const String themeModeSystem = 'System';
  static const String accentColor = 'Accent Color';

  // ============================================================
  // HISTORY LABELS
  // ============================================================

  static const String historyTitle = 'History';
  static const String historyEmpty = 'No calculations yet';
  static const String historyClearAll = 'Clear All';
  static const String historyClearConfirm = 'Clear all history?';
  static const String historyClearCancel = 'Cancel';

  // ============================================================
  // DISPLAY TEXT
  // ============================================================

  /// Initial display value.
  static const String initialValue = '0';

  /// Placeholder for empty expression.
  static const String emptyExpression = '';

  // ============================================================
  // ERROR MESSAGES
  // ============================================================

  /// Generic error message.
  static const String error = 'Error';

  /// Division by zero error.
  static const String errorDivisionByZero = 'Cannot divide by zero';

  /// Invalid expression error.
  static const String errorInvalidExpression = 'Invalid expression';

  /// Result too large error.
  static const String errorOverflow = 'Result too large';

  /// Undefined result (e.g., 0/0).
  static const String errorUndefined = 'Undefined';

  // ============================================================
  // ACCESSIBILITY LABELS
  // ============================================================

  // These labels are read by screen readers (VoiceOver/TalkBack)

  static const String a11yZero = 'Zero';
  static const String a11yOne = 'One';
  static const String a11yTwo = 'Two';
  static const String a11yThree = 'Three';
  static const String a11yFour = 'Four';
  static const String a11yFive = 'Five';
  static const String a11ySix = 'Six';
  static const String a11ySeven = 'Seven';
  static const String a11yEight = 'Eight';
  static const String a11yNine = 'Nine';

  static const String a11yPlus = 'Plus';
  static const String a11yMinus = 'Minus';
  static const String a11yMultiply = 'Multiply';
  static const String a11yDivide = 'Divide';
  static const String a11yEquals = 'Equals';

  static const String a11yClear = 'Clear';
  static const String a11yAllClear = 'All clear';
  static const String a11yBackspace = 'Backspace';
  static const String a11yDecimal = 'Decimal point';
  static const String a11yPercent = 'Percent';
  static const String a11yPlusMinus = 'Plus or minus';
  static const String a11yOpenParen = 'Open parenthesis';
  static const String a11yCloseParen = 'Close parenthesis';
  static const String a11ySettings = 'Settings';
  static const String a11yHistory = 'History';

  static const String a11yDisplay = 'Calculator display';
  static const String a11yExpression = 'Current expression';
  static const String a11yResult = 'Result';

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Converts a display operator to its calculation equivalent.
  ///
  /// Display uses Unicode symbols (×, ÷, −) for better appearance,
  /// but the calculator engine needs ASCII operators (*, /, -).
  static String toCalcOperator(String displayOperator) {
    switch (displayOperator) {
      case multiply:
        return multiplyCalc;
      case divide:
        return divideCalc;
      case minus:
        return minusCalc;
      default:
        return displayOperator;
    }
  }

  /// Converts a calculation operator to its display equivalent.
  static String toDisplayOperator(String calcOperator) {
    switch (calcOperator) {
      case multiplyCalc:
        return multiply;
      case divideCalc:
        return divide;
      case minusCalc:
        return minus;
      default:
        return calcOperator;
    }
  }
}
