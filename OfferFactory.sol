// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Offer.sol";

contract OfferFactory {
     event DepositMismatch(uint256 sent, uint256 required);
    Offer[] public offers;

    function createOffer(string memory _name, uint _surface, uint _price, uint _deposit) public {
        Offer newOffer = new Offer(_name, _surface, _price, _deposit);
        offers.push(newOffer);
    }

 function signOffer(uint _offerIndex) public payable {
        Offer offer = offers[_offerIndex];
        uint256 requiredDeposit = offer.deposit();

        // Emituj wydarzenie z wartościami
        emit DepositMismatch(msg.value, requiredDeposit);

        // Sprawdzenie, czy wysłana kwota jest równa wymaganemu depozytowi
        // require(msg.value == requiredDeposit, "Deposit must match the offer deposit amount");
    offer.signOffer();
    offer.setDepositor(payable(msg.sender)); // Wywołaj funkcję setDepositor
}


    function archiveOffer(uint _offerIndex) public {
        Offer offer = offers[_offerIndex];
        offer.archiveOffer();
    }

    // Funkcja do pobierania statusu konkretnej oferty
    function getOfferStatus(uint _offerIndex) public view returns (Offer.Status) {
        Offer offer = offers[_offerIndex];
        return offer.status();
    }

    // Funkcja zwracająca liczbę ofert
    function getOffersCount() public view returns (uint) {
        return offers.length;
    }

    // Opcjonalnie, funkcja umożliwiająca odczyt adresów wszystkich ofert
    function getAllOffers() public view returns (Offer[] memory) {
        return offers;
    }

    function getAllOffersData() public view returns (address[] memory, string[] memory, uint[] memory, uint[] memory, uint[] memory, Offer.Status[] memory) {
    address[] memory addresses = new address[](offers.length);
    string[] memory names = new string[](offers.length);
    uint[] memory surfaces = new uint[](offers.length);
    uint[] memory prices = new uint[](offers.length);
    uint[] memory deposits = new uint[](offers.length);
    Offer.Status[] memory statuses = new Offer.Status[](offers.length);

    for (uint i = 0; i < offers.length; i++) {
        Offer offer = offers[i];
        addresses[i] = address(offer);
        names[i] = offer.name();
        surfaces[i] = offer.surface();
        prices[i] = offer.price();
        deposits[i] = offer.deposit();
        statuses[i] = offer.status();
    }

    return (addresses, names, surfaces, prices, deposits, statuses);
}


}
