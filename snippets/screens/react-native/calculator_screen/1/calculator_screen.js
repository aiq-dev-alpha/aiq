import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
  Dimensions,
  ScrollView
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';

const { width } = Dimensions.get('window');

const CalculatorScreen = () => {
  const [display, setDisplay] = useState('0');
  const [previousValue, setPreviousValue] = useState('');
  const [operation, setOperation] = useState('');
  const [userIsTyping, setUserIsTyping] = useState(false);
  const [history, setHistory] = useState([]);
  const [showHistory, setShowHistory] = useState(false);

  const numberPressed = (number) => {
    if (userIsTyping) {
      if (display.length < 12) {
        setDisplay(display === '0' ? number : display + number);
      }
    } else {
      setDisplay(number);
      setUserIsTyping(true);
    }
  };

  const decimalPressed = () => {
    if (!display.includes('.') && userIsTyping) {
      setDisplay(display + '.');
    } else if (!userIsTyping) {
      setDisplay('0.');
      setUserIsTyping(true);
    }
  };

  const operationPressed = (op) => {
    if (previousValue && operation && userIsTyping) {
      calculateResult();
    }
    setPreviousValue(display);
    setOperation(op);
    setUserIsTyping(false);
  };

  const calculateResult = () => {
    if (!previousValue || !operation) return;

    const prev = parseFloat(previousValue);
    const current = parseFloat(display);
    let result = 0;

    const calculation = `${previousValue} ${operation} ${display}`;

    switch (operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
        result = prev * current;
        break;
      case '÷':
        if (current !== 0) {
          result = prev / current;
        } else {
          alert('Cannot divide by zero');
          return;
        }
        break;
      case '%':
        result = prev % current;
        break;
      case '^':
        result = Math.pow(prev, current);
        break;
      default:
        return;
    }

    const formattedResult = formatResult(result);
    setDisplay(formattedResult);
    setHistory(prev => [`${calculation} = ${formattedResult}`, ...prev.slice(0, 49)]);
    setPreviousValue('');
    setOperation('');
    setUserIsTyping(false);
  };

  const clear = () => {
    setDisplay('0');
    setPreviousValue('');
    setOperation('');
    setUserIsTyping(false);
  };

  const clearEntry = () => {
    setDisplay('0');
    setUserIsTyping(false);
  };

  const backspace = () => {
    if (userIsTyping && display.length > 1) {
      setDisplay(display.slice(0, -1));
    } else {
      setDisplay('0');
      setUserIsTyping(false);
    }
  };

  const toggleSign = () => {
    if (display !== '0') {
      setDisplay(display.startsWith('-') ? display.slice(1) : `-${display}`);
    }
  };

  const scientificFunction = (func) => {
    const current = parseFloat(display);
    let result = 0;
    let calculation = `${func}(${display})`;

    try {
      switch (func) {
        case 'sin':
          result = Math.sin((current * Math.PI) / 180);
          break;
        case 'cos':
          result = Math.cos((current * Math.PI) / 180);
          break;
        case 'tan':
          result = Math.tan((current * Math.PI) / 180);
          break;
        case 'ln':
          if (current > 0) {
            result = Math.log(current);
          } else {
            alert('Invalid input for ln');
            return;
          }
          break;
        case 'log':
          if (current > 0) {
            result = Math.log10(current);
          } else {
            alert('Invalid input for log');
            return;
          }
          break;
        case '√':
          if (current >= 0) {
            result = Math.sqrt(current);
          } else {
            alert('Invalid input for √');
            return;
          }
          break;
        case 'x²':
          result = current * current;
          calculation = `(${display})²`;
          break;
        case '1/x':
          if (current !== 0) {
            result = 1 / current;
            calculation = `1/(${display})`;
          } else {
            alert('Cannot divide by zero');
            return;
          }
          break;
        case '!':
          if (current >= 0 && current === Math.floor(current) && current <= 170) {
            result = factorial(current);
            calculation = `${display}!`;
          } else {
            alert('Invalid input for factorial');
            return;
          }
          break;
        case 'π':
          result = Math.PI;
          calculation = 'π';
          break;
        case 'e':
          result = Math.E;
          calculation = 'e';
          break;
        default:
          return;
      }

      const formattedResult = formatResult(result);
      setDisplay(formattedResult);
      setHistory(prev => [`${calculation} = ${formattedResult}`, ...prev.slice(0, 49)]);
      setUserIsTyping(false);
    } catch (error) {
      alert('Math error');
    }
  };

  const factorial = (n) => {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  };

  const formatResult = (result) => {
    if (result === Infinity || result === -Infinity) return 'Infinity';
    if (isNaN(result)) return 'Error';

    if (result === Math.floor(result)) {
      return result.toString();
    } else {
      const formatted = result.toString();
      if (formatted.includes('e')) {
        return result.toExponential(6);
      }
      if (formatted.length > 12) {
        return result.toFixed(8);
      }
      return formatted;
    }
  };

  const Button = ({ text, onPress, style, textStyle, icon }) => (
    <TouchableOpacity
      style={[styles.button, style]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      {icon ? (
        <Ionicons name={icon} size={20} color={textStyle?.color || '#000'} />
      ) : (
        <Text style={[styles.buttonText, textStyle]}>{text}</Text>
      )}
    </TouchableOpacity>
  );

  const ScientificButton = ({ text, onPress }) => (
    <TouchableOpacity
      style={styles.scientificButton}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <Text style={styles.scientificButtonText}>{text}</Text>
    </TouchableOpacity>
  );

  if (showHistory) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => setShowHistory(false)}>
            <Ionicons name="calculator" size={24} color="#007AFF" />
          </TouchableOpacity>
          <Text style={styles.headerTitle}>History</Text>
          <TouchableOpacity onPress={() => setHistory([])}>
            <Text style={styles.clearHistoryText}>Clear</Text>
          </TouchableOpacity>
        </View>
        <ScrollView style={styles.historyContainer}>
          {history.length === 0 ? (
            <View style={styles.emptyHistory}>
              <Text style={styles.emptyHistoryText}>No calculations yet</Text>
            </View>
          ) : (
            history.map((item, index) => (
              <TouchableOpacity
                key={index}
                style={styles.historyItem}
                onPress={() => {
                  const result = item.split(' = ')[1];
                  setDisplay(result);
                  setShowHistory(false);
                  setUserIsTyping(false);
                }}
              >
                <Text style={styles.historyItemText}>{item}</Text>
              </TouchableOpacity>
            ))
          )}
        </ScrollView>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Calculator</Text>
        <TouchableOpacity onPress={() => setShowHistory(true)}>
          <Ionicons name="time" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>

      {/* Display */}
      <View style={styles.displayContainer}>
        {operation && (
          <Text style={styles.operationText}>
            {previousValue} {operation}
          </Text>
        )}
        <Text style={styles.displayText} adjustsFontSizeToFit>
          {display}
        </Text>
      </View>

      {/* Scientific Functions */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        style={styles.scientificContainer}
        contentContainerStyle={styles.scientificContent}
      >
        <ScientificButton text="sin" onPress={() => scientificFunction('sin')} />
        <ScientificButton text="cos" onPress={() => scientificFunction('cos')} />
        <ScientificButton text="tan" onPress={() => scientificFunction('tan')} />
        <ScientificButton text="ln" onPress={() => scientificFunction('ln')} />
        <ScientificButton text="log" onPress={() => scientificFunction('log')} />
        <ScientificButton text="√" onPress={() => scientificFunction('√')} />
        <ScientificButton text="x²" onPress={() => scientificFunction('x²')} />
        <ScientificButton text="1/x" onPress={() => scientificFunction('1/x')} />
        <ScientificButton text="x!" onPress={() => scientificFunction('!')} />
        <ScientificButton text="π" onPress={() => scientificFunction('π')} />
        <ScientificButton text="e" onPress={() => scientificFunction('e')} />
      </ScrollView>

      {/* Button Grid */}
      <View style={styles.buttonContainer}>
        {/* First Row */}
        <View style={styles.buttonRow}>
          <Button text="C" onPress={clear} style={styles.operatorButton} textStyle={styles.operatorText} />
          <Button text="CE" onPress={clearEntry} style={styles.operatorButton} textStyle={styles.operatorText} />
          <Button icon="backspace-outline" onPress={backspace} style={styles.operatorButton} textStyle={styles.operatorText} />
          <Button text="÷" onPress={() => operationPressed('÷')} style={styles.primaryButton} textStyle={styles.primaryText} />
        </View>

        {/* Second Row */}
        <View style={styles.buttonRow}>
          <Button text="7" onPress={() => numberPressed('7')} />
          <Button text="8" onPress={() => numberPressed('8')} />
          <Button text="9" onPress={() => numberPressed('9')} />
          <Button text="×" onPress={() => operationPressed('×')} style={styles.primaryButton} textStyle={styles.primaryText} />
        </View>

        {/* Third Row */}
        <View style={styles.buttonRow}>
          <Button text="4" onPress={() => numberPressed('4')} />
          <Button text="5" onPress={() => numberPressed('5')} />
          <Button text="6" onPress={() => numberPressed('6')} />
          <Button text="-" onPress={() => operationPressed('-')} style={styles.primaryButton} textStyle={styles.primaryText} />
        </View>

        {/* Fourth Row */}
        <View style={styles.buttonRow}>
          <Button text="1" onPress={() => numberPressed('1')} />
          <Button text="2" onPress={() => numberPressed('2')} />
          <Button text="3" onPress={() => numberPressed('3')} />
          <Button text="+" onPress={() => operationPressed('+')} style={styles.primaryButton} textStyle={styles.primaryText} />
        </View>

        {/* Fifth Row */}
        <View style={styles.buttonRow}>
          <Button text="±" onPress={toggleSign} />
          <Button text="0" onPress={() => numberPressed('0')} />
          <Button text="." onPress={decimalPressed} />
          <Button text="=" onPress={calculateResult} style={styles.primaryButton} textStyle={styles.primaryText} />
        </View>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
    backgroundColor: '#fff',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
  },
  clearHistoryText: {
    color: '#007AFF',
    fontSize: 16,
  },
  displayContainer: {
    flex: 1,
    backgroundColor: '#000',
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    padding: 20,
  },
  operationText: {
    color: '#888',
    fontSize: 18,
    marginBottom: 8,
  },
  displayText: {
    color: '#fff',
    fontSize: 48,
    fontWeight: '300',
  },
  scientificContainer: {
    backgroundColor: '#f0f0f0',
    maxHeight: 60,
  },
  scientificContent: {
    paddingVertical: 8,
    paddingHorizontal: 4,
  },
  scientificButton: {
    backgroundColor: '#e8e8e8',
    paddingHorizontal: 12,
    paddingVertical: 8,
    marginHorizontal: 2,
    borderRadius: 6,
    minWidth: 50,
    alignItems: 'center',
  },
  scientificButtonText: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#666',
  },
  buttonContainer: {
    backgroundColor: '#fff',
    paddingVertical: 8,
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 1,
  },
  button: {
    width: (width - 5) / 4,
    height: 70,
    backgroundColor: '#f8f8f8',
    justifyContent: 'center',
    alignItems: 'center',
    marginHorizontal: 1,
  },
  buttonText: {
    fontSize: 24,
    color: '#333',
  },
  operatorButton: {
    backgroundColor: '#ff9500',
  },
  operatorText: {
    color: '#fff',
  },
  primaryButton: {
    backgroundColor: '#007AFF',
  },
  primaryText: {
    color: '#fff',
  },
  historyContainer: {
    flex: 1,
    backgroundColor: '#fff',
  },
  emptyHistory: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 100,
  },
  emptyHistoryText: {
    fontSize: 16,
    color: '#999',
  },
  historyItem: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  historyItemText: {
    fontSize: 16,
    color: '#333',
    fontFamily: 'Courier',
  },
});

export default CalculatorScreen;