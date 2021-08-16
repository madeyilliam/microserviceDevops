@isTest
private class SDO_Community_KnowledgeSearchTest {
    static testMethod void myPhonyTest() {
        SDO_Community_knowledgeSearch_CT x = new SDO_Community_knowledgeSearch_CT();
        SDO_Community_ArticleDataCategory y = new SDO_Community_ArticleDataCategory();
        y = new SDO_Community_ArticleDataCategory('data_category_name','api_name','article_type');
        y = new SDO_Community_ArticleDataCategory('data_category_name','api_name','article_type', 'parent-api');
    }
}