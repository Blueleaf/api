# Blueleaf API Documentation

## Overview

We are exposing some account data via a read only API.  Users can get API tokens directly from the Blueleaf web interface.

All requests are behind an SSL-protected (HTTPS) service, and use HTTP basic authentication.  Use the user API token as the "username" part of an http basic auth request, use anything you'd like for the "password" part.

## Deprecation Notice

The following will be removed in a future version of the API:

    <holding>
      <id /> // The id attribute will be removed. Please use <holding-id> to relate new holdings to historical holdings
    </holding>

    <account>
      <number /> //The number attribute will be removed. Please use <account-number>
    </account>

## Usage

There is a blueleaf_client.rb demo script in this repository. It shows how one might use HTTParty to access the service.

### Basic Testing

In some cases there is a benefit to querying the API directly, rather than through software.

* Users new to the API may try it without investing in development
* Developers experiencing issues should query directly to verify whether the problem is in their code on the API itself.

#### Browser Testing

* Using any browser, access the URL in question, or http://secure.blueleaf.com/api/v1/households.xml
* When prompted for HTTP authentication, supply the token as the username. Leave the password blank.

#### Command Line Testing

    % curl --user <token>:skip-password https://secure.blueleaf.com/api/v1/advisor.xml

## Requests
All requests are scoped relative to the API token provided. API tokens may be generated at the administrator level across multiple advisors in a firm or they may be generated at the individual advisor level and show only the households that advisor may access.

### Admin summary

    GET /api/v1/advisor.xml

    <advisor>
      <email>advisor@example.com</email>
      <full-name>User Fullname</full-name>
    </advisor>

### Households listing

    GET /api/v1/households.xml

    <households>
      <household>
        <id>123</id>
        <email>client@example.com</email>
        <full-name>John Smith</full-name>
      </household>
    </households>

### Household detail

    GET /api/v1/households/123.xml

    <household>
      <id>123</id>
      <email>client@example.com</email>
      <full-name>John Smith</full-name>
      <accounts>
        <account>
          <institution-name>Fidelity</institution-name>
          <id>456</id>
          <name>Savings</name>
          <account-number>0001234567</account-number>
          <current-net-value>$123,456.00</current-net-value>
          <last-update>2011-01-01T11:11:11Z</last-update>
          <holdings>
            <holding>
              <holding-id>789</holding-id>
              <description>Apple, Inc stock</description>
              <period>2011-01-01</period>
              <price>345.67</price>
              <value>34567.00</value>
              <quantity>100</quantity>
              <ticker-name>AAPL</ticker-name>
              <company-name>Apple, Inc</company-name>
            </holding>
          </holdings>
          <account-type>
            <name>individual</name>
            <display-name>individual</display-name>
          </account-type>
        </account>
      </accounts>
    <household>

### Multiple households with details (beta)

**WARNING** This feature is beta-only. The interface is not final, and may change without notice.

If you supply a 'page' parameter to the households request, you will get paginated detailed output.
Page numbers are zero-indexed.

Implementations must handle page size dynamically, including the possibility of variably-sized pages.
Blueleaf reserves the right to adjust the page blocking algorithm.

Note: It is possible for an advisor to add or remove a client between calls for different pages.
To be certain that your list is complete, compare the results of your paginated data collection to the
summary (unpaginated) households request (/api/v1/households.xml). If necessary, fill in missing clients
with the single-household details request (api/v1/households/1.xml)

    GET /api/v1/households.xml?page=0

    <households>
      <current_page>0</current_page>
      <total_pages>3</total_pages>
      <household>
        <id>123</id>
        <email>client@example.com</email>
        <full-name>John Smith</full-name>
        <accounts>
          <account>
            <institution-name>Fidelity</institution-name>
            <id>456</id>
            <name>Savings</name>
            <current-net-value>$123,456.00</current-net-value>
            <last-update>2011-01-01T11:11:11Z</last-update>
            <holdings>
              <holding>
                <id>789</id>
                <description>Apple, Inc stock</description>
                <period>2011-01-01</period>
                <price>345.67</price>
                <value>34567.00</value>
                <quantity>100</quantity>
                <ticker-name>AAPL</ticker-name>
                <company-name>Apple, Inc</company-name>
              </holding>
            </holdings>
            <account-type>
              <name>individual</name>
              <display-name>individual</display-name>
            </account-type>
          </account>
        </accounts>
      <household>
    </households>

## Transactions (beta)

### Transactions Overview

The transactions API has two entry-points:

    /api/v1/transactions.xml
    /api/v1/households/:household_id/transactions.xml

and two options:

    since_id
    page

The first entry point is for bulk downloading. The second one is for a particular household.

### Parameters

If you supply no options, then you will get the last transaction for the query. Transactions are delivered in order of their id. We use an id-based "high water mark" synchronization technique. The bare query is an efficient/quick way to find out if you are up to date or not. If you have the transaction that it returns, then no new transactions have been added since your last pull.

If you supply a "since_id", you will get all transactions that have been imported since the one who's id you supplied. There is never a transaction 0, so you can always get all transactions by supplying since_id=0. Note: we do **not** return the transaction with the id that you specify. You should read the query as "return all transactions that have been imported since transaction N". This means you can also test for new transactions by supplying the last transaction ID in your system as the since_id. If there are no new transactions, you will get an empty transaction list back.

If you do not supply a page, then you will get page 0 of the query. If you do, then you will get that page. Page numbers start at zero, so e.g. specifying page=1 gives you the *second* page, etc.

### Iteration

The page size is currently set at 100 transactions, but this may change and it may even be dynamic. You should drive your iteration as follows:

Every query returns two additional attributes - the current page and the total number of pages for the query. Note that the number of pages can change between queries, as can the number of queries on the last page. This will happen if additional transactions are imported by our system between your queries. You should only take the page count as a guide, guarantee. Instead, you should terminate your iteration in one of three ways:

* when you get a page who's current_page == total_pages - 1
* when you get a page with an empty <transactions /> list.

For future updates, you should supply a since_id equal to the id of the last transaction in your system (or the last one for the household if you are using that entry point).


### Example

The example below uses the bulk entry point. It shows collecting the latest transaction only, then collecting all transactions, followed by a final iteration returning no transactions.

    $ curl "https://TDMSMK66W43oaadT5WZ3JWPa@secure.blueleaf.com/api/v1/transactions?since_id=0"
    <?xml version="1.0" encoding="UTF-8"?>
    <transactions>
      <current_page>0</current_page>
      <total_pages>40</total_pages>
      <transaction>
        <account-id>1936</account-id>
        <amount>600.0</amount>
        <cancelled-on nil="true"></cancelled-on>
        <description>Tfr BANK OF AMERICA, N, CHRISTOPHER THORtype: MONEYLINK TRANSFER</description>
        <id>4285146</id>
        <period>2011-02-11</period>
        <price nil="true"></price>
        <quantity nil="true"></quantity>
        <symbol nil="true"></symbol>
        <symbol-type nil="true"></symbol-type>
        <transaction-date>2011-02-10T21:00:00-11:00</transaction-date>
        <transaction-category>Transfer</transaction-category>
        <security-type nil="true"></security-type>
      </transaction>
      <!--
        output ommitted for brevity
      -->
      <transaction>
        <account-id>873</account-id>
        <amount>2.58</amount>
        <cancelled-on nil="true"></cancelled-on>
        <description>FIDELITY CASH RESERVES - DIVIDEND RECEIVED</description>
        <id>4312857</id>
        <period>2010-12-31</period>
        <price nil="true"></price>
        <quantity nil="true"></quantity>
        <symbol>FDRXX</symbol>
        <symbol-type nil="true"></symbol-type>
        <transaction-date>2010-12-30T21:00:00-11:00</transaction-date>
        <transaction-category>Dividend</transaction-category>
        <security-type>moneyMarketFund</security-type>
      </transaction>
    </transactions>

    $ curl "https://TDMSMK66W43oaadT5WZ3JWPa@secure.blueleaf.com/api/v1/transactions?since_id=0&page=1"
    # output omitted

    $ curl "https://TDMSMK66W43oaadT5WZ3JWPa@secure.blueleaf.com/api/v1/transactions?since_id=0&page=2"
    # output omitted

    $ curl "https://TDMSMK66W43oaadT5WZ3JWPa@secure.blueleaf.com/api/v1/transactions?since_id=0&page=39"
    <?xml version="1.0" encoding="UTF-8"?>
    <transactions>
      <current_page>39</current_page>
      <total_pages>40</total_pages>
      <transaction>
        <account-id>9468</account-id>
        <amount>-168.35</amount>
        <cancelled-on nil="true"></cancelled-on>
        <description>Preauthorized Debit-VERIZON ONLINE PMT</description>
        <id>15379934</id>
        <period>2014-01-10</period>
        <price nil="true"></price>
        <quantity nil="true"></quantity>
        <symbol nil="true"></symbol>
        <symbol-type nil="true"></symbol-type>
        <transaction-date>2014-01-09T21:00:00-11:00</transaction-date>
        <transaction-category>Uncategorized</transaction-category>
        <security-type nil="true"></security-type>
      </transaction>
      <!--
        output omitted for brevity
      -->
      <transaction>
        <account-id>9468</account-id>
        <amount>90.0</amount>
        <cancelled-on nil="true"></cancelled-on>
        <description>ATM Deposit-DDA DEPOSIT</description>
        <id>15784241</id>
        <period>2014-02-03</period>
        <price nil="true"></price>
        <quantity nil="true"></quantity>
        <symbol nil="true"></symbol>
        <symbol-type nil="true"></symbol-type>
        <transaction-date>2014-02-02T21:00:00-11:00</transaction-date>
        <transaction-category>Uncategorized</transaction-category>
        <security-type nil="true"></security-type>
      </transaction>
    </transactions>

    $ curl "https://TDMSMK66W43oaadT5WZ3JWPa@secure.blueleaf.com/api/v1/transactions?since_id=0&page=40"
    <?xml version="1.0" encoding="UTF-8"?>
    <transactions/>
    $

## Schema (partial)

Some fields in the API have values that come from a list. These lists are dynamic, they can change in the future depending on the advisor's usage of the system.

API clients must be able to handle future values that are unknown at implementation time. The list of possible values can be queried via a partial schema interface.

The following is a sample of possible values only. Please refer to the live API for the current complete list.

    GET /api/v1/schema.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <schema>
      <households type="array">
        <household>
          <accounts type="array">
            <account>
              <account-type>
                <values type="array">
                  <value>
                    <display-name>401k</display-name>
                    <name>401k</name>
                  </value>
                  <value>
                    <display-name>Annuity</display-name>
                    <name>annuity</name>
                  </value>
                  <value>
                    <display-name>Custodial</display-name>
                    <name>custodial</name>
                  </value>
                  <value>
                    <display-name>ESOPP</display-name>
                    <name>esopp</name>
                  </value>
                  <value>
                    <display-name>Individual</display-name>
                    <name>individual</name>
                  </value>
                </values>
              </account-type>
              <holdings type="array">
                <holding>
                  <holding-type>
                    <values type="array">
                      <value>
                        <name>bond</name>
                      </value>
                      <value>
                        <name>currency</name>
                      </value>
                      <value>
                        <name>mutualFund</name>
                      </value>
                      <value>
                        <name>stock</name>
                      </value>
                      <value>
                        <name>moneyMarketFund</name>
                      </value>
                    </values>
                  </holding-type>
                </holding>
              </holdings>
            </account>
          </accounts>
        </household>
      </households>
    </schema>

## Creating Users

You can create clients of a firm by sending a POST request containing an `email` address, a `full_name` string, and an optional `password`. If you do not supply a password, the client will have to use the password recovery feature to set a password. 

If the request succeeds, the household object will be returned. If it fails, the HTTP response code will indicate the nature of the problem, and the body will contain an error string. 

### Possible errors

The following error conditions can result from an otherwise valid request:

* 400: INVALID_EMAIL_ADDRESS - The email address is missing or invalid
* 409: EMAIL_IN_USE - a user account with this email address already exists

### Examples

    # Curl notes:
    # * -d causes a POST request and adds form data to the request
    # * you must quote -d values if they contain spaces
    # * -w "%{http_code} causes curl to display the HTTP status code

    # Email in use
    $ curl --user <token>:skip -d email=john@blueleaf.com -d "full_name=John Prendergast" -w "%{http_code}\n" http://localhost:3000/api/v1/households
    <?xml version="1.0" encoding="UTF-8"?>
    <hash>
      <error>EMAIL_IN_USE</error>
    </hash>
    RESPONSE CODE: 409

    # Invalid or missing email
    $ curl --user <token>:skip -d "full_name=John Prendergast" -w "%{http_code}\n" http://localhost:3000/api/v1/households                          
    <?xml version="1.0" encoding="UTF-8"?>
    <hash>
      <error>INVALID_EMAIL_ADDRESS</error>
    </hash>
    RESPONSE CODE: 400
    $ curl --user <token>:skip -d email=john_p@blueleaf. -d "full_name=John Prendergast" -w "%{http_code}\n" http://localhost:3000/api/v1/households
    <?xml version="1.0" encoding="UTF-8"?>
    <hash>
      <error>INVALID_EMAIL_ADDRESS</error>
    </hash>
    RESPONSE CODE: 400

    # Success
    $ curl --user <token>:skip -d email=john_p@blueleaf.com -d "full_name=John Prendergast" -w "%{http_code}\n" http://localhost:3000/api/v1/households
    <?xml version="1.0" encoding="UTF-8"?>
    <households>
      <email>john_p@blueleaf.com</email>
      <first-name>John</first-name>
      <full-name>John Prendergast</full-name>
      <id>45</id>
      <last-name>Prendergast</last-name>
    </households>
    RESPONSE CODE: 200
    $ 
