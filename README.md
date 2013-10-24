# Blueleaf API Documentation

## Overview

We are exposing some account data via a read only API.  Users can get API tokens directly from the Blueleaf web interface.

All requests are behind an SSL-protected (HTTPS) service, and use HTTP basic authentication.  Use the user API token as the "username" part of an http basic auth request, use anything you'd like for the "password" part.

## Deprecation Notice

The following will be removed in a future version of the API:

    <holding>
      <id /> // The id attribute will be removed. Please use <holding-id> to relate new holdings to historical holdings
    </holding>
    
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

### Schema (partial)

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


## Support

Use the github issues feature of this project to request new functionality or report problems.
