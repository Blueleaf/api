# Blueleaf API Documentation

## Overview

We are exposing some account data via a read only API.  Users can get API tokens directly from the Blueleaf web interface.

All requests are behind an SSL-protected (HTTPS) service, and use HTTP basic authentication.  Use the user API token as the "username" part of an http basic auth request, use anything you'd like for the "password" part.

## Usage

There is a blueleaf_client.rb demo script in this repository. It shows how one might use HTTParty to access the service.

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
          </account-type>
        </account>
      </accounts>
    <household>

### Personal summary

    GET /api/v1/personal.xml

    # Returns the same XML as the household detail response

## Support

Use the github issues feature of this project to request new functionality or report problems.