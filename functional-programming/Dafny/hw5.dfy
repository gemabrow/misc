// Program: hw5.dfy
// Authors: Gerald Brown and Ivan Alvarado
// On this homework, we worked together for 6 hours,
// Gerald worked independently for 12+ hours,
// and Ivan worked independently for 8+ hours.

// Gerald Brown
// gemabrow@ucsc.edu
//
// Ivan Alvarado
// ivalvara@ucsc.edu

// 1. Implement a Min function in Dafny that returns the minimum of two
// integers and add appropiate post-condition(s).

method Min(a: int, b: int) returns (c: int)
  // add post conditions
  ensures c == minFunc(a, b)
{
  // implement the method
  if a < b { return a; }
  else { return b; }
}

// function for ensuring method Min
// has correct output
function minFunc(x: int, y: int): int
{
    if x < y then x else y
}

method TestMin()
{
  var m := Min(12,5);
  assert m == 5;
  var n := Min(23,42);
  assert n == 23;
}

// 2. The following Dafny method searches an array of integers for an element
// and returns the index of the first occurance of that element. If the array
// does not include the element, Search should return -1. Add pre-,
// post-conditions and loop invariants to make the code compile and to
// statically verify the assertions in the TestSearch method.

method Search(arr: array<int>, element: int) returns (idx: int)
  requires arr != null
  // index can only return values in this range
  ensures -1 <= idx < arr.Length
  // index of found element in array returned
  ensures idx >= 0 ==> idx < arr.Length && arr[idx] == element
  // index -1 returned, element not in array
  ensures idx == -1 <==> ( forall k :: 0 <= k < arr.Length ==> arr[k] != element )
{
  var n := 0;
  while n < arr.Length
    invariant 0 <= n <= arr.Length
    invariant forall k :: 0 <= k < n ==> arr[k] != element
  {
    if (arr[n] == element) {
      return n;
    }
    n := n + 1;
  }
  return -1;
}

method TestSearch()
{
  var arr := new int[3];
  arr[0] := 23;
  arr[1] := 21;
  arr[2] := 22;
  var s := Search(arr, 21);
  assert s == 1;
  var t := Search(arr, 20);
  assert t == -1;
}

// 3. EX CREDIT: Like the Search method in question 2, the following method
// searches an array and returns the first occurance of that element it finds.
// However, it requires the array to be sorted and is implemented via binary
// search. Add pre-, post-conditions and loop invariants to make the code
// compile and to statically verify the assertions in the TestBinarySearch
// method.

method BinarySearch(arr: array<int>, element: int) returns (idx: int)
  requires arr != null && sorted(arr)
  ensures -1 <= idx < arr.Length
  ensures idx >= 0 ==> idx < arr.Length && arr[idx] == element
  ensures idx == -1 <==> ( forall k :: 0 <= k < arr.Length ==> arr[k] != element )
{
  if (arr.Length == 0) {
    return -1;
  }
  var left := 0;
  var right := arr.Length;
  while (left < right)
    invariant 0 <= left <= right <= arr.Length
    invariant forall i ::
      0 <= i < arr.Length && !(left <= i < right) ==> arr[i] != element
  {
    var mid := (left + right) / 2;
    if (arr[mid] == element) {
      return mid;
    }
    if (arr[mid] < element) {
      left := mid + 1;
    } else {
      right := mid;
    }
  }
  return -1;
}

// checks that all elements in an array are sorted in incr order
// and returns true if the case, otherwise false
predicate sorted(arr: array<int>)
  reads arr
  requires arr != null
{
  forall j, k :: 0 <= j < k < arr.Length ==> arr[j] <= arr[k]
}

method TestBinarySearch()
{
  var arr := new int[3];
  arr[0] := 21;
  arr[1] := 22;
  arr[2] := 23;
  var s := BinarySearch(arr, 22);
  assert s == 1;
  var t := BinarySearch(arr, 24);
  assert t == -1;
}
