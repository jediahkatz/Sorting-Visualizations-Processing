int[] a; //array
int progress = -1; //marks how far algorithm has sorted
int iterator = -1; //what algorithm is currently iterating through
int it2 = -1;
int specialIndex = -1; //special index - pivot,min, etc.
int comparisons = 0;
int arrayAccesses = 0;

int numBars = 100; //SET THIS VALUE: NUMBER OF VALUES TO SORT
float delay = 5; //SET THIS VALUE: DELAY IN MILLISEC
String algorithm = "quick"; //SET THIS VALUE: "selection", "insertion", "merge", or "quick"

void setup() {
  size(1060, 620); //1040,585
  noStroke();
  stroke(0);
  //background(0);
  a = getRandomArray(numBars);
  thread("sort");
}

void draw() {
  background(0);
  fill(255);
  text("Comparisons: " + comparisons, 10, 15);
  text("Array accesses: " + arrayAccesses, 150, 15);
  drawArray(a);
}

void sort() {
  switch(algorithm) {
  case "selection":
    selectionSort(a);
    break;
  case "insertion":
    insertionSort(a);
    break;
  case "merge":
    mergeSort(a);
    break;
  case "quick":
    quicksort(a);
    break;
  default:
    selectionSort(a);
  }
}

void quicksort(int[] a) {
  quicksort(a, 0, a.length-1);
}

void quicksort(int[] a, int low, int high) {
  if(low >= high) {
    return;
  }
  
  int i = low;
  int j = high;
  //pivot is median of three random values
  int p = (low+high)/2;
  int pivot = a[p];
  specialIndex = p;

  while (i <= j) {
    while (a[i] < pivot) {
      i++;
      delay(delay);
    }
    while (a[j] > pivot) {
      j--;
      delay(delay);
    }
    if (i <= j) {
      swap(a, i, j);
      //if (p == i) { 
      //  p = j;
      //} else if (p == j) { 
      //  p = i;
      //}

      i++;
      j--;
      delay(delay);
    }
  }
  println(low,j,i,high);
  if (low < j) {
    quicksort(a, low, j);
  }
  if (i < high) {
    quicksort(a, i, high);
  }
}

void mergeSort(int[] a) {
  mergeSort(a, 0, a.length);
  iterator = it2 = -1;
  runThrough(a);
}

void mergeSort(int[] a, int low, int high) {
  if (low + 1 < high) {
    int mid = (low + high)/2;
    mergeSort(a, low, mid);
    mergeSort(a, mid, high);

    merge(a, low, mid, high);
  }
}

void merge(int[] a, int low, int mid, int high) {
  int[] temp = new int[high-low];
  int i=low;
  int j=mid;
  int k = -1;

  while (k < temp.length-1) {
    iterator = i;
    it2 = j;
    //comparisons++;
    temp[++k] = (j > high-1 || (i <= mid-1 && a[i] < a[j])) ? a[i++] : a[j++];
    comparisons ++;
    arrayAccesses += 2;
    delay(delay);
  }
  it2 = -1;

  for (i=0; i<temp.length; i++) {
    iterator = low + i;
    a[low + i] = temp[i];
    arrayAccesses++;
    delay(delay);
  }
}

//Insertion sort
void insertionSort(int[] a) {
  for (int i=1; i<a.length; i++) {
    int val = a[i];
    arrayAccesses++;
    progress = i;

    int j = i-1;
    while (j>=0 && a[j] > val) {
      comparisons++;
      arrayAccesses++;
      iterator = j;
      swap(a, j, j+1);
      j--;
      delay(delay);
    }
  }
  iterator = -1;
  runThrough(a);
  progress = -1;
}

//Selection sort
void selectionSort(int[] a) {
  int n = a.length;
  int i=0;
  int min=0;
  while (i < n) {
    min = i;
    for (int j=i+1; j<n; j++) {
      iterator = j;
      if (a[j] < a[min]) {
        min = specialIndex = j;
      }
      comparisons++; 
      arrayAccesses+=2;
      delay(delay);
    }
    swap(a, i, min);
    progress = i;
    i++;
  }
  iterator = specialIndex = -1;
  runThrough(a);
  progress = -1;
}

void runThrough(int[] a) {
  for (int i=0; i<a.length; i++) {
    progress = i;
    delay(delay+5);
  }
}

//Draw rectangles representing an array of ints
void drawArray(int[] a) {
  int n=a.length; //size, and also max value
  strokeWeight(100/n);
  float x_inc = 1040*(1.0/n); //multiplicative factor x
  float y_inc = 585.0/n; //multiplicative factor y
  for (int i=0; i<n; i++) {
    int val = a[i];
    if (i == progress) {
      fill(0, 255, 0);
    } else if (i == iterator || i == it2) {
      fill(255, 0, 0);
    } else if (i == specialIndex) {
      fill(0, 0, 255);
    } else {
      fill(255);
    }
    rect(10+i*x_inc, 615-(val*y_inc), x_inc, val*y_inc);
  }
}

//Returns an array of size n containing
//integers 1 through n in a random order
int[] getRandomArray(int n) {
  int[] a = new int[n];
  for (int i=0; i<n; i++) {
    a[i] = i+1;
  }
  shuffle(a);
  return a;
}

//Put the contents of an array in a random order
//Uses Durstenfeld's Fisher-Yates algorithm
void shuffle(int[] a) {
  int n = a.length;
  for (int i=0; i<n-1; i++) {
    int j = (int) random(0, n-i);
    swap(a, i, i+j);
  }
}

//Swaps array elements at indices i and j
void swap(int[] a, int i, int j) {
  if (i == j) return;
  int temp = a[i];
  a[i] = a[j];
  arrayAccesses+=2;
  a[j] = temp;
}

void delay(float millis) {
  int nanos = (int) ((millis % 1)*1000000);

  try {
    Thread.sleep((int) millis, nanos);
  } 
  catch(InterruptedException e) {
    println("oops");
  }
}