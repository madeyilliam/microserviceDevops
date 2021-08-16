({
    setUserEmail : function(component) {
        var action = component.get("c.getEmail");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                (function (i, s, o, g, r, a, m) {
                    i["GoogleAnalyticsObject"] = r;
                    (i[r] =
                     i[r] ||
                     function () {
                         (i[r].q = i[r].q || []).push(arguments);
                     }),
                        (i[r].l = 1 * new Date());
                    (a = s.createElement(o)), (m = s.getElementsByTagName(o)[0]);
                    a.async = 1;
                    a.src = g;
                    m.parentNode.insertBefore(a, m);
                })(window, document, "script", "/resource/SDO_Tool_DemoAppTrackGA", "ga");
                let org = component.get("v.page");
                
                let dimensionValue = response.getReturnValue();
                console.log('user email: ', dimensionValue);
                
                if(org==''){
                    org = 'SDO';
                }
                let page = component.get("v.org")+' '+org;
                console.log("in ga", ga, page);
                ga("create", "UA-183945453-1", "auto");
                ga('set', 'dimension1', dimensionValue);
                ga("send", {
                    hitType: "event",
                    eventCategory: "pageview",
                    eventAction: "view",
                    eventLabel: page
                });
                //ga("send", "pageview", page);
            }
            else {
                // do something
                console.log('insight helper failed');
            }
        })
        
        $A.enqueueAction(action);
    }
})