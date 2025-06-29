# Currencies
A Swift micro-framework for representing currencies.

Many frameworks for dealing with currencies already exist. In some frameworks you have the same basic type for representing amounts in all currencies. This either fails to have validation when two amounts from different currencies are added - or needs detailed error handling, meaning that simple expressions involving currency amounts suddenly require error handling too.
Another framework like https://github.com/danthorpe/Money has strongly typed currencies. This means that in the code you need to know exactly which currency you are dealing with. While this is an excellent concept for some purposes, I don't think that it is very convenient for dealing with dynamically defined currencies.

The Currencies framework chooses a path between the two above.

Here the CurrencyAmount type defines an amount in some 'base currency'. This means that two CurrencyAmounts can always be added or subtracted, since by definition they are in the same currency.

Foreign currency amounts are modelled by a ForeignCurrencyAmount type. This type requires the currency to be explicitly stated for each amount, and this means that runtime checks can be made for operations like addition and subtraction.

The rationale here is, that many use cases are similar to a shop selling items in a specific currency. For specifying prices it may be sufficient to have the prices in a single base currency.

If the shop accepts foreign currencies for payment, then the ForeignCurrencyAmount type can be used to represent this.

The CurrencyAmount is a pure value type with a backing value representation using the most excellent Swift 3 Decimal type.
