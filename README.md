**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Blueleaf API Documentation](#blueleaf-api-documentation)
	- [Overview](#overview)
	- [Usage](#usage)
		- [Basic Testing](#basic-testing)
			- [Browser Testing](#browser-testing)
			- [Command Line Testing](#command-line-testing)
	- [Requests](#requests)
		- [Advisor summary](#advisor-summary)
		- [Advisor households listing](#advisor-households-listing)
		- [Advisor household detail](#advisor-household-detail)
		- [Personal summary](#personal-summary)
		- [Schema (partial)](#schema-partial)
	- [Support](#support)

# Blueleaf API Documentation

## Overview

We are exposing some account data via a read only API.  Users can get API tokens directly from the Blueleaf web interface.

All requests are behind an SSL-protected (HTTPS) service, and use HTTP basic authentication.  Use the user API token as the "username" part of an http basic auth request, use anything you'd like for the "password" part.

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

### Advisor summary

    GET /api/v1/advisor.xml

    <advisor>
      <email>advisor@example.com</email>
      <full-name>User Fullname</full-name>
    </advisor>

### Advisor households listing

    GET /api/v1/households.xml

    <households>
      <household>
        <id>123</id>
        <email>client@example.com</email>
        <full-name>John Smith</full-name>
      </household>
    </households>

### Advisor household detail

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

### Personal summary

    GET /api/v1/personal.xml

    # Returns the same XML as the household detail response

### Schema (partial)

Some fields in the API have values that come from a list. These lists are dynamic, they can change in the future depending on the advisor's usage of the system.

API clients must be able to handle future values that are unknown at implementation time. The list of possible values can be queried via a partial schema interface.

The following represents only the possible values that were valid at the time of this writing.

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
                    <display-name>401a</display-name>
                    <name>401a</name>
                  </value>
                  <value>
                    <display-name>401k</display-name>
                    <name>401k</name>
                  </value>
                  <value>
                    <display-name>403b</display-name>
                    <name>403b</name>
                  </value>
                  <value>
                    <display-name>457 Deferred Compensation</display-name>
                    <name>457DeferredCompensation</name>
                  </value>
                  <value>
                    <display-name>529 Plan</display-name>
                    <name>529Plan</name>
                  </value>
                  <value>
                    <display-name>Annuity</display-name>
                    <name>annuity</name>
                  </value>
                  <value>
                    <display-name>Bank Deposit</display-name>
                    <name>Bank Deposit</name>
                  </value>
                  <value>
                    <display-name>BrokerageCash</display-name>
                    <name>brokerageCash</name>
                  </value>
                  <value>
                    <display-name>BrokerageMargin</display-name>
                    <name>brokerageMargin</name>
                  </value>
                  <value>
                    <display-name>CD</display-name>
                    <name>CD</name>
                  </value>
                  <value>
                    <display-name>Checking</display-name>
                    <name>checking</name>
                  </value>
                  <value>
                    <display-name>College Savings</display-name>
                    <name>College Savings</name>
                  </value>
                  <value>
                    <display-name>Corporate</display-name>
                    <name>corporate</name>
                  </value>
                  <value>
                    <display-name>Credit Card</display-name>
                    <name>Credit Card</name>
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
                  <value>
                    <display-name>Individual</display-name>
                    <name>Individual</name>
                  </value>
                  <value>
                    <display-name>IRA</display-name>
                    <name>ira</name>
                  </value>
                  <value>
                    <display-name>Joint By Entirety</display-name>
                    <name>jointByEntirety</name>
                  </value>
                  <value>
                    <display-name>JTTIC</display-name>
                    <name>jttic</name>
                  </value>
                  <value>
                    <display-name>JTWROS</display-name>
                    <name>jtwros</name>
                  </value>
                  <value>
                    <display-name>Loan</display-name>
                    <name>Loan</name>
                  </value>
                  <value>
                    <display-name>Money Market</display-name>
                    <name>moneyMarket</name>
                  </value>
                  <value>
                    <display-name>Mortgage</display-name>
                    <name>Mortgage</name>
                  </value>
                  <value>
                    <display-name>MPP</display-name>
                    <name>mpp</name>
                  </value>
                  <value>
                    <display-name>Other Asset</display-name>
                    <name>other</name>
                  </value>
                  <value>
                    <display-name>Other Liability</display-name>
                    <name>Other Liability</name>
                  </value>
                  <value>
                    <display-name>Other Loan</display-name>
                    <name>Other Loan</name>
                  </value>
                  <value>
                    <display-name>PSP</display-name>
                    <name>psp</name>
                  </value>
                  <value>
                    <display-name>Restricted Stock Award</display-name>
                    <name>restrictedStockAward</name>
                  </value>
                  <value>
                    <display-name>Rollover IRA</display-name>
                    <name>rollover</name>
                  </value>
                  <value>
                    <display-name>Roth IRA</display-name>
                    <name>roth</name>
                  </value>
                  <value>
                    <display-name>Roth IRA</display-name>
                    <name>Roth IRA</name>
                  </value>
                  <value>
                    <display-name>Savings</display-name>
                    <name>savings</name>
                  </value>
                  <value>
                    <display-name>SEP IRA</display-name>
                    <name>sep</name>
                  </value>
                  <value>
                    <display-name>simple</display-name>
                    <name>simple</name>
                  </value>
                  <value>
                    <display-name>Student Loan</display-name>
                    <name>Student Loan</name>
                  </value>
                  <value>
                    <display-name>Traditional IRA</display-name>
                    <name>Traditional IRA</name>
                  </value>
                  <value>
                    <display-name>Trust</display-name>
                    <name>trust</name>
                  </value>
                  <value>
                    <display-name>UGMA</display-name>
                    <name>ugma</name>
                  </value>
                  <value>
                    <display-name>Unknown</display-name>
                    <name>unknown</name>
                  </value>
                  <value>
                    <display-name>Unsecured Loan</display-name>
                    <name>Unsecured Loan</name>
                  </value>
                  <value>
                    <display-name>UTMA</display-name>
                    <name>utma</name>
                  </value>
                  <value>
                    <display-name nil="true"></display-name>
                    <name>communityProperty</name>
                  </value>
                  <value>
                    <display-name nil="true"></display-name>
                    <name>stockBasket</name>
                  </value>
                  <value>
                    <display-name nil="true"></display-name>
                    <name>educational</name>
                  </value>
                  <value>
                    <display-name nil="true"></display-name>
                    <name>partnership</name>
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
                        <name>unknown</name>
                      </value>
                      <value>
                        <name>currency</name>
                      </value>
                      <value>
                        <name>mutualFund</name>
                      </value>
                      <value>
                        <name>future</name>
                      </value>
                      <value>
                        <name>commodity</name>
                      </value>
                      <value>
                        <name>employeeStockOption</name>
                      </value>
                      <value>
                        <name>CD</name>
                      </value>
                      <value>
                        <name>stock</name>
                      </value>
                      <value>
                        <name>option</name>
                      </value>
                      <value>
                        <name>moneyMarketFund</name>
                      </value>
                      <value>
                        <name>unitInvestmentTrust</name>
                      </value>
                      <value>
                        <name>remic</name>
                      </value>
                      <value>
                        <name>other</name>
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