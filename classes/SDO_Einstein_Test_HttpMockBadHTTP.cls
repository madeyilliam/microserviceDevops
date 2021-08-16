@isTest
public with sharing class SDO_Einstein_Test_HttpMockBadHTTP implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(404);
        return res;
    }
}