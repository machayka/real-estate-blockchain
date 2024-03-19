// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Offer {
    string public name;
    uint public surface;
    uint public price;
    uint public deposit;
    address payable public depositor; // Dodajemy zmienną do przechowywania adresu wpłacającego
    Status public status;

    enum Status { ACTIVE, SIGNED, ARCHIVED }

    constructor(string memory _name, uint _surface, uint _price, uint _deposit) {
        name = _name;
        surface = _surface;
        price = _price;
        deposit = _deposit;
        status = Status.ACTIVE; // Domyślnie ustawiamy status na ACTIVE
    }

function setDepositor(address payable _depositor) public {
    // Opcjonalnie, dodaj sprawdzenie, czy depositor jest już ustawiony, aby zapobiec nadpisaniu.
    // Może być to ważne, jeśli chcesz ograniczyć, kto i kiedy może ustawić depositor.
    require(depositor == address(0), "Depositor already set.");
    depositor = _depositor;
}


    // Funkcje do zmiany statusu oferty
    function signOffer() public {
        status = Status.SIGNED;
    }

    function archiveOffer() public {
        require(depositor != address(0), "Depositor address not set."); // Upewniamy się, że adres wpłacającego został ustawiony
        status = Status.ARCHIVED;
        depositor.transfer(deposit); // Zwracamy depozyt na adres wpłacającego
    }
}
