#include <iostream>
#include <unordered_map>
#include <string>

int main() {
    std::unordered_map<std::string, int> myMap;

    myMap["apple"] = 10;
    myMap["banana"] = 20;
    myMap["orange"] = 30;

    for (const auto& pair : myMap) {
        std::cout << pair.first << ": " << pair.second << std::endl;
    }

    return 0;
}