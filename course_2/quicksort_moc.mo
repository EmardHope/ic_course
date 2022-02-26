import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";

Debug.print("Quick Sort:");

func partition(myArray:[var Int], low:Nat, high:Nat):Nat{
    let pivot = myArray[low];
    var i = low;
    var j = high;

    while(i < j){
        while((i < j) and (myArray[j] >= pivot)){
            j -= 1;
        };
        myArray[i] := myArray[j];
        while((i < j) and (myArray[i] <= pivot)){
            i += 1;   
        };
        myArray[j] := myArray[i];
        };
        myArray[i] := pivot;
        return i;
    };

func quicksort(myArray:[var Int], low:Nat, high:Nat){
    if(low < high){
        let k = partition(myArray, low, high);
        quicksort(myArray, low, k);
        quicksort(myArray, k+1, high);
    };
};

let the_array:[var Int] = [var 19,13,12,10,13];
quicksort(the_array,0,4);

for (ii in the_array.vals()){
    Debug.print(Int.toText(ii));
}