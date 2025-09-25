import 'dart:math' as math;

// Stack implementation
class Stack<T> {
  List<T> _items = [];

  void push(T item) => _items.add(item);
  T? pop() => _items.isEmpty ? null : _items.removeLast();
  T? peek() => _items.isEmpty ? null : _items.last;
  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
}


// Queue implementation
class Queue<T> {
  List<T> _items = [];

  void enqueue(T item) => _items.add(item);
  T? dequeue() => _items.isEmpty ? null : _items.removeAt(0);
  T? front() => _items.isEmpty ? null : _items.first;
  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
}

// Linked List Node
class Node<T> {
  T data;
  Node<T>? next;
  Node(this.data);
}

void main() {
  // Variables and basic types
  int x = 10;
  List<int> nums = [3, 1, 4, 1, 5];

  print("Dart Syntax & Algorithms");
  print("-" * 30);

  // Control flow
  if (x > 5) {
    print("x is greater than 5");
  }

  for (int i = 0; i < 3; i++) {
    print("Loop $i");
  }

  nums.forEach((n) => print("Item: $n"));

  // Sorting Algorithms

  // Bubble Sort
  List<int> bubbleSort(List<int> arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }
    }
    return arr;
  }

  // Quick Sort
  List<int> quickSort(List<int> arr) {
    if (arr.length <= 1) return arr;

    int pivot = arr[arr.length ~/ 2];
    List<int> less = [];
    List<int> equal = [];
    List<int> greater = [];

    for (int num in arr) {
      if (num < pivot) {
        less.add(num);
      } else if (num == pivot) {
        equal.add(num);
      } else {
        greater.add(num);
      }
    }

    return [...quickSort(less), ...equal, ...quickSort(greater)];
  }

  // Merge helper function
  List<int> merge(List<int> left, List<int> right) {
    List<int> result = [];
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        result.add(left[i++]);
      } else {
        result.add(right[j++]);
      }
    }

    result.addAll(left.sublist(i));
    result.addAll(right.sublist(j));
    return result;
  }

  // Merge Sort
  List<int> mergeSort(List<int> arr) {
    if (arr.length <= 1) return arr;

    int mid = arr.length ~/ 2;
    List<int> left = mergeSort(arr.sublist(0, mid));
    List<int> right = mergeSort(arr.sublist(mid));

    return merge(left, right);
  }

  // Insertion Sort
  List<int> insertionSort(List<int> arr) {
    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = key;
    }
    return arr;
  }

  // Searching Algorithms

  // Linear Search
  int linearSearch(List<int> arr, int target) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == target) return i;
    }
    return -1;
  }

  // Binary Search
  int binarySearch(List<int> arr, int target) {
    int left = 0;
    int right = arr.length - 1;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;

      if (arr[mid] == target) {
        return mid;
      } else if (arr[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return -1;
  }

  // Jump Search
  int jumpSearch(List<int> arr, int target) {
    int n = arr.length;
    int step = math.sqrt(n).toInt();
    int prev = 0;

    while (arr[(step < n ? step : n) - 1] < target) {
      prev = step;
      step += math.sqrt(n).toInt();
      if (prev >= n) return -1;
    }

    while (arr[prev] < target) {
      prev++;
      if (prev == (step < n ? step : n)) return -1;
    }

    if (arr[prev] == target) return prev;
    return -1;
  }

  // Test sorting
  print("\nSorting Algorithms:");
  List<int> test1 = [64, 34, 25, 12, 22, 11, 90];
  print("Original: $test1");
  print("Bubble Sort: ${bubbleSort([...test1])}");
  print("Quick Sort: ${quickSort([...test1])}");
  print("Merge Sort: ${mergeSort([...test1])}");
  print("Insertion Sort: ${insertionSort([...test1])}");

  // Test searching
  print("\nSearching Algorithms:");
  List<int> sorted = [11, 12, 22, 25, 34, 64, 90];
  int target = 25;
  print("Array: $sorted");
  print("Target: $target");
  print("Linear Search index: ${linearSearch(sorted, target)}");
  print("Binary Search index: ${binarySearch(sorted, target)}");
  print("Jump Search index: ${jumpSearch(sorted, target)}");

  // Test data structures
  print("\nData Structures:");

  Stack<int> stack = Stack();
  stack.push(10);
  stack.push(20);
  stack.push(30);
  print("Stack pop: ${stack.pop()}");
  print("Stack peek: ${stack.peek()}");

  Queue<String> queue = Queue();
  queue.enqueue("first");
  queue.enqueue("second");
  queue.enqueue("third");
  print("Queue dequeue: ${queue.dequeue()}");
  print("Queue front: ${queue.front()}");

  // Common algorithms

  // Fibonacci
  int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }

  // Factorial
  int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }

  // GCD
  int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  // Prime check
  bool isPrime(int n) {
    if (n <= 1) return false;
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  print("\nCommon Algorithms:");
  print("Fibonacci(7): ${fibonacci(7)}");
  print("Factorial(5): ${factorial(5)}");
  print("GCD(48, 18): ${gcd(48, 18)}");
  print("Is 17 prime? ${isPrime(17)}");

  // String algorithms

  // Reverse string
  String reverseString(String s) {
    return s.split('').reversed.join('');
  }

  // Palindrome check
  bool isPalindrome(String s) {
    String clean = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return clean == reverseString(clean);
  }

  // Anagram check
  bool areAnagrams(String s1, String s2) {
    var chars1 = s1.toLowerCase().split('')..sort();
    var chars2 = s2.toLowerCase().split('')..sort();
    return chars1.join() == chars2.join();
  }

  print("\nString Algorithms:");
  print("Reverse 'hello': ${reverseString('hello')}");
  print("Is 'racecar' palindrome? ${isPalindrome('racecar')}");
  print("Are 'listen' and 'silent' anagrams? ${areAnagrams('listen', 'silent')}");
}