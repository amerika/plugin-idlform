(function(a){var c=window.Modernizr,i=a.webshims,h=i.bugs,m=a('<form action="#" style="width: 1px; height: 1px; overflow: hidden;"><select name="b" required="" /><input type="date" required="" name="a" /><input type="submit" /></form>'),r=function(){if(m[0].querySelector)try{h.findRequired=!m[0].querySelector("select:required")}catch(a){h.findRequired=!1}};h.findRequired=!1;h.validationMessage=!1;h.valueAsNumberSet=!1;i.capturingEventPrevented=function(c){if(!c._isPolyfilled){var h=c.isDefaultPrevented,
j=c.preventDefault;c.preventDefault=function(){clearTimeout(a.data(c.target,c.type+"DefaultPrevented"));a.data(c.target,c.type+"DefaultPrevented",setTimeout(function(){a.removeData(c.target,c.type+"DefaultPrevented")},30));return j.apply(this,arguments)};c.isDefaultPrevented=function(){return!(!h.apply(this,arguments)&&!a.data(c.target,c.type+"DefaultPrevented"))};c._isPolyfilled=!0}};if(!c.formvalidation||h.bustedValidity)r();else if(i.capturingEvents(["input"]),i.capturingEvents(["invalid"],!0),
c.bugfreeformvalidation=!0,window.opera||a.browser.webkit||window.testGoodWithFix){var j=a("input",m).eq(0),u,z=function(a){i.loader.loadList(["dom-extend"]);i.ready("dom-extend",a)},s=function(h){var n=["form-extend","form-message","form-native-fix"];h&&(h.preventDefault(),h.stopImmediatePropagation());clearTimeout(u);setTimeout(function(){m&&(m.remove(),m=j=null)},9);if(!c.bugfreeformvalidation)i.addPolyfill("form-native-fix",{f:"forms",d:["form-extend"]}),i.modules["form-extend"].test=a.noop;i.isReady("form-number-date-api")&&
n.push("form-number-date-api");i.reTest(n);if(j)try{j.prop({disabled:!0,value:""}).prop("disabled",!1).is(":valid")&&z(function(){i.onNodeNamesPropertyModify(["input","textarea"],["disabled","readonly"],{set:function(c){!c&&this&&a.prop(this,"value",a.prop(this,"value"))}});i.onNodeNamesPropertyModify(["select"],["disabled","readonly"],{set:function(c){if(!c&&this)c=a(this).val(),(a("option:last-child",this)[0]||{}).selected=!0,a(this).val(c)}})})}catch(v){}(a.browser.opera||window.testGoodWithFix)&&
z(function(){var c=function(a){a.preventDefault()};["form","input","textarea","select"].forEach(function(h){var j=i.defineNodeNameProperty(h,"checkValidity",{prop:{value:function(){i.fromSubmit||a(this).bind("invalid.checkvalidity",c);i.fromCheckValidity=!0;var b=j.prop._supvalue.apply(this,arguments);i.fromSubmit||a(this).unbind("invalid.checkvalidity",c);i.fromCheckValidity=!1;return b}}})})})};m.appendTo("head");if(window.opera||window.testGoodWithFix){r();h.validationMessage=!j.prop("validationMessage");
if((c.inputtypes||{}).date){try{j.prop("valueAsNumber",0)}catch(v){}h.valueAsNumberSet="1970-01-01"!=j.prop("value")}j.prop("value","")}m.bind("submit",function(a){c.bugfreeformvalidation=!1;s(a)});u=setTimeout(function(){m&&m.triggerHandler("submit")},9);a("input, select",m).bind("invalid",s).filter('[type="submit"]').bind("click",function(a){a.stopImmediatePropagation()}).trigger("click");a.browser.webkit&&c.bugfreeformvalidation&&!i.bugs.bustedValidity&&function(){var c=/^(?:textarea|input)$/i,
h=!1;document.addEventListener("contextmenu",function(a){c.test(a.target.nodeName||"")&&(h=a.target.form)&&setTimeout(function(){h=!1},1)},!1);a(window).bind("invalid",function(a){if(a.originalEvent&&h&&h==a.target.form)a.wrongWebkitInvalid=!0,a.stopImmediatePropagation()})}()}})(jQuery);
jQuery.webshims.register("form-core",function(a,c,i,h,m,r){var j={radio:1},u={checkbox:1,radio:1},z=a([]),s=c.bugs,v=function(b){var b=a(b),d,c;d=z;if(j[b[0].type])c=b.prop("form"),d=(d=b[0].name)?c?a(c[d]):a(h.getElementsByName(d)).filter(function(){return!a.prop(this,"form")}):b,d=d.filter('[type="radio"]');return d},t=c.getContentValidationMessage=function(b,d,c){var g=a(b).data("errormessage")||b.getAttribute("x-moz-errormessage")||"";c&&g[c]&&(g=g[c]);"object"==typeof g&&(d=d||a.prop(b,"validity")||
{valid:1},d.valid||a.each(d,function(a,b){if(b&&"valid"!=a&&g[a])return g=g[a],!1}));if("object"==typeof g)g=g.defaultMessage;return g||""},n={number:1,range:1,date:1};a.extend(a.expr[":"],{"valid-element":function(b){return!(!a.prop(b,"willValidate")||!(a.prop(b,"validity")||{valid:1}).valid)},"invalid-element":function(b){return!(!a.prop(b,"willValidate")||(a.prop(b,"validity")||{valid:1}).valid)},"required-element":function(b){return!(!a.prop(b,"willValidate")||!a.prop(b,"required"))},"optional-element":function(b){return!!(a.prop(b,
"willValidate")&&!1===a.prop(b,"required"))},"in-range":function(b){if(!n[a.prop(b,"type")]||!a.prop(b,"willValidate"))return!1;b=a.prop(b,"validity");return!(!b||b.rangeOverflow||b.rangeUnderflow)},"out-of-range":function(b){if(!n[a.prop(b,"type")]||!a.prop(b,"willValidate"))return!1;b=a.prop(b,"validity");return!(!b||!b.rangeOverflow&&!b.rangeUnderflow)}});["valid","invalid","required","optional"].forEach(function(b){a.expr[":"][b]=a.expr.filters[b+"-element"]});a.expr[":"].focus=function(a){try{var d=
a.ownerDocument;return a===d.activeElement&&(!d.hasFocus||d.hasFocus())}catch(c){}return!1};var y=a.event.customEvent||{};(s.bustedValidity||s.findRequired||!Modernizr.bugfreeformvalidation)&&function(){var b=a.find,d=a.find.matchesSelector,c=/(\:valid|\:invalid|\:optional|\:required|\:in-range|\:out-of-range)(?=[\s\[\~\.\+\>\:\#*]|$)/ig,g=function(a){return a+"-element"};a.find=function(){var a=Array.prototype.slice,d=function(d){var k=arguments,k=a.call(k,1,k.length);k.unshift(d.replace(c,g));return b.apply(this,
k)},B;for(B in b)b.hasOwnProperty(B)&&(d[B]=b[B]);return d}();if(!Modernizr.prefixed||Modernizr.prefixed("matchesSelector",h.documentElement))a.find.matchesSelector=function(a,b){b=b.replace(c,g);return d.call(this,a,b)}}();var w=a.prop,C={selectedIndex:1,value:1,checked:1,disabled:1,readonly:1};a.prop=function(b,d,c){var g=w.apply(this,arguments);if(b&&"form"in b&&C[d]&&c!==m&&a(b).hasClass("form-ui-invalid")&&(a.prop(b,"validity")||{valid:1}).valid)a(b).getShadowElement().removeClass("form-ui-invalid"),
"checked"==d&&c&&v(b).not(b).removeClass("form-ui-invalid").removeAttr("aria-invalid");return g};var p=function(b,d){var c;a.each(b,function(b,o){if(o)return c="customError"==b?a.prop(d,"validationMessage"):b,!1});return c};a(h).bind(r.validityUIEvents||"focusout change refreshvalidityui",function(b){var d,c;if(b.target&&(d=a(b.target).getNativeElement()[0],!("submit"==d.type||!a.prop(d,"willValidate")||"focusout"==b.type&&"radio"==b.type))){c=a.data(d,"webshimsswitchvalidityclass");var g=function(){var c=
a.prop(d,"validity"),k=a(d).getShadowElement(),f,x,g,l;a(d).trigger("refreshCustomValidityRules");c.valid?k.hasClass("form-ui-valid")||(f="form-ui-valid",x="form-ui-invalid",l="changedvaliditystate",g="changedvalid",u[d.type]&&d.checked&&v(d).not(d).removeClass(x).addClass(f).removeAttr("aria-invalid"),a.removeData(d,"webshimsinvalidcause")):(c=p(c,d),a.data(d,"webshimsinvalidcause")!=c&&(a.data(d,"webshimsinvalidcause",c),l="changedvaliditystate"),k.hasClass("form-ui-invalid")||(f="form-ui-invalid",
x="form-ui-valid",u[d.type]&&!d.checked&&v(d).not(d).removeClass(x).addClass(f),g="changedinvalid"));f&&(k.addClass(f).removeClass(x),setTimeout(function(){a(d).trigger(g)},0));l&&setTimeout(function(){a(d).trigger(l)},0);a.removeData(b.target,"webshimsswitchvalidityclass")};c&&clearTimeout(c);"refreshvalidityui"==b.type?g():a.data(b.target,"webshimsswitchvalidityclass",setTimeout(g,9))}});y.changedvaliditystate=!0;y.refreshCustomValidityRules=!0;y.changedvalid=!0;y.changedinvalid=!0;y.refreshvalidityui=
!0;c.triggerInlineForm=function(b,d){a(b).trigger(d)};c.modules["form-core"].getGroupElements=v;s=function(){c.scrollRoot=a.browser.webkit||"BackCompat"==h.compatMode?a(h.body):a(h.documentElement)};s();c.ready("DOM",s);c.getRelOffset=function(b,d){var b=a(b),c=a(d).offset(),g;a.swap(a(b)[0],{visibility:"hidden",display:"inline-block",left:0,top:0},function(){g=b.offset()});c.top-=g.top;c.left-=g.left;return c};c.validityAlert=function(){var b=!a.browser.msie||7<parseInt(a.browser.version,10)?"span":
"label",d,f=!1,g=!1,o,k={hideDelay:5E3,showFor:function(b,d,c,l){k._create();var b=a(b),q=a(b).getShadowElement(),A=k.getOffsetFromBody(q);k.clear();l?this.hide():(this.getMessage(b,d),this.position(q,A),this.show(),this.hideDelay&&(f=setTimeout(o,this.hideDelay)),a(i).bind("resize.validityalert",function(){clearTimeout(g);g=setTimeout(function(){k.position(q)},9)}));c||this.setFocus(q,A)},getOffsetFromBody:function(a){return c.getRelOffset(d,a)},setFocus:function(k,f){var g=a(k).getShadowFocusElement(),
l=c.scrollRoot.scrollTop(),q=(f||g.offset()).top-30,A;c.getID&&"label"==b&&d.attr("for",c.getID(g));l>q&&(c.scrollRoot.animate({scrollTop:q-5},{queue:!1,duration:Math.max(Math.min(600,1.5*(l-q)),80)}),A=!0);try{g[0].focus()}catch(j){}A&&(c.scrollRoot.scrollTop(l),setTimeout(function(){c.scrollRoot.scrollTop(l)},0));setTimeout(function(){a(h).bind("focusout.validityalert",o)},10)},getMessage:function(b,c){c||(c=t(b[0])||b.prop("validationMessage"));c?a("span.va-box",d).text(c):this.hide()},position:function(b,
c){c=c?a.extend({},c):k.getOffsetFromBody(b);c.top+=b.outerHeight();d.css(c)},show:function(){"none"===d.css("display")&&d.css({opacity:0}).show();d.addClass("va-visible").fadeTo(400,1)},hide:function(){d.removeClass("va-visible").fadeOut()},clear:function(){clearTimeout(!1);clearTimeout(f);a(h).unbind(".validityalert");a(i).unbind(".validityalert");d.stop().removeAttr("for")},_create:function(){if(!d)d=k.errorBubble=a("<"+b+' class="validity-alert-wrapper" role="alert"><span  class="validity-alert"><span class="va-arrow"><span class="va-arrow-box"></span></span><span class="va-box"></span></span></'+
b+">").css({position:"absolute",display:"none"}),c.ready("DOM",function(){d.appendTo("body");a.fn.bgIframe&&a.browser.msie&&7>parseInt(a.browser.version,10)&&d.bgIframe()})}};o=a.proxy(k,"hide");return k}();(function(){var b,d=[],c;a(h).bind("invalid",function(g){if(!g.wrongWebkitInvalid){var o=a(g.target),k=o.getShadowElement();k.hasClass("form-ui-invalid")||(k.addClass("form-ui-invalid").removeClass("form-ui-valid"),setTimeout(function(){a(g.target).trigger("changedinvalid").trigger("changedvaliditystate")},
0));if(!b)b=a.Event("firstinvalid"),b.isInvalidUIPrevented=g.isDefaultPrevented,k=a.Event("firstinvalidsystem"),a(h).triggerHandler(k,{element:g.target,form:g.target.form,isInvalidUIPrevented:g.isDefaultPrevented}),o.trigger(b);b&&b.isDefaultPrevented()&&g.preventDefault();d.push(g.target);g.extraData="fix";clearTimeout(c);c=setTimeout(function(){var c={type:"lastinvalid",cancelable:!1,invalidlist:a(d)};b=!1;d=[];a(g.target).trigger(c,c)},9);k=o=null}})})();a.fn.getErrorMessage=function(){var b="",
c=this[0];c&&(b=t(c)||a.prop(c,"customValidationMessage")||a.prop(c,"validationMessage"));return b};r.replaceValidationUI&&c.ready("DOM forms",function(){a(h).bind("firstinvalid",function(b){b.isInvalidUIPrevented()||(b.preventDefault(),a.webshims.validityAlert.showFor(b.target,a(b.target).prop("customValidationMessage")))})})});
jQuery.webshims.register("form-message",function(a,c,i,h,m,r){var j=c.validityMessages,i=r.overrideMessages||r.customMessages?["customValidationMessage"]:[];j.en=a.extend(!0,{typeMismatch:{email:"Please enter an email address.",url:"Please enter a URL.",number:"Please enter a number.",date:"Please enter a date.",time:"Please enter a time.",range:"Invalid input.","datetime-local":"Please enter a datetime."},rangeUnderflow:{defaultMessage:"Value must be greater than or equal to {%min}."},rangeOverflow:{defaultMessage:"Value must be less than or equal to {%max}."},
stepMismatch:"Invalid input.",tooLong:"Please enter at most {%maxlength} character(s). You entered {%valueLen}.",patternMismatch:"Invalid input. {%title}",valueMissing:{defaultMessage:"Please fill out this field.",checkbox:"Please check this box if you want to proceed."}},j.en||j["en-US"]||{});["select","radio"].forEach(function(a){j.en.valueMissing[a]="Please select an option."});["date","time","datetime-local"].forEach(function(a){j.en.rangeUnderflow[a]="Value must be at or after {%min}."});["date",
"time","datetime-local"].forEach(function(a){j.en.rangeOverflow[a]="Value must be at or before {%max}."});j["en-US"]=j["en-US"]||j.en;j[""]=j[""]||j["en-US"];j.de=a.extend(!0,{typeMismatch:{email:"{%value} ist keine zul\u00e4ssige E-Mail-Adresse",url:"{%value} ist keine zul\u00e4ssige Webadresse",number:"{%value} ist keine Nummer!",date:"{%value} ist kein Datum",time:"{%value} ist keine Uhrzeit",range:"{%value} ist keine Nummer!","datetime-local":"{%value} ist kein Datum-Uhrzeit Format."},rangeUnderflow:{defaultMessage:"{%value} ist zu niedrig. {%min} ist der unterste Wert, den Sie benutzen k\u00f6nnen."},
rangeOverflow:{defaultMessage:"{%value} ist zu hoch. {%max} ist der oberste Wert, den Sie benutzen k\u00f6nnen."},stepMismatch:"Der Wert {%value} ist in diesem Feld nicht zul\u00e4ssig. Hier sind nur bestimmte Werte zul\u00e4ssig. {%title}",tooLong:"Der eingegebene Text ist zu lang! Sie haben {%valueLen} Zeichen eingegeben, dabei sind {%maxlength} das Maximum.",patternMismatch:"{%value} hat f\u00fcr dieses Eingabefeld ein falsches Format! {%title}",valueMissing:{defaultMessage:"Bitte geben Sie einen Wert ein",
checkbox:"Bitte aktivieren Sie das K\u00e4stchen"}},j.de||{});["select","radio"].forEach(function(a){j.de.valueMissing[a]="Bitte w\u00e4hlen Sie eine Option aus"});["date","time","datetime-local"].forEach(function(a){j.de.rangeUnderflow[a]="{%value} ist zu fr\u00fch. {%min} ist die fr\u00fcheste Zeit, die Sie benutzen k\u00f6nnen."});["date","time","datetime-local"].forEach(function(a){j.de.rangeOverflow[a]="{%value} ist zu sp\u00e4t. {%max} ist die sp\u00e4teste Zeit, die Sie benutzen k\u00f6nnen."});
var u=j[""];c.createValidationMessage=function(h,j){var i=u[j];i&&"string"!==typeof i&&(i=i[a.prop(h,"type")]||i[(h.nodeName||"").toLowerCase()]||i.defaultMessage);i&&"value,min,max,title,maxlength,label".split(",").forEach(function(t){if(-1!==i.indexOf("{%"+t)){var n=("label"==t?a.trim(a('label[for="'+h.id+'"]',h.form).text()).replace(/\*$|:$/,""):a.attr(h,t))||"";"patternMismatch"==j&&"title"==t&&!n&&c.error("no title for patternMismatch provided. Always add a title attribute.");i=i.replace("{%"+
t+"}",n);"value"==t&&(i=i.replace("{%valueLen}",n.length))}});return i||""};(c.bugs.validationMessage||!Modernizr.formvalidation||c.bugs.bustedValidity)&&i.push("validationMessage");c.activeLang({langObj:j,module:"form-core",callback:function(a){u=a}});i.forEach(function(h){c.defineNodeNamesProperty(["fieldset","output","button"],h,{prop:{value:"",writeable:!1}});["input","select","textarea"].forEach(function(i){var j=c.defineNodeNameProperty(i,h,{prop:{get:function(){var h=this,i="";if(!a.prop(h,
"willValidate"))return i;var m=a.prop(h,"validity")||{valid:1};if(m.valid||(i=c.getContentValidationMessage(h,m)))return i;if(m.customError&&h.nodeName&&(i=Modernizr.formvalidation&&!c.bugs.bustedValidity&&j.prop._supget?j.prop._supget.call(h):c.data(h,"customvalidationMessage")))return i;a.each(m,function(a,j){if("valid"!=a&&j&&(i=c.createValidationMessage(h,a)))return!1});return i||""},writeable:!1}})})})});
(!Modernizr.formvalidation||jQuery.webshims.bugs.bustedValidity)&&jQuery.webshims.register("form-extend",function(a,c,i,h){c.inputTypes=c.inputTypes||{};var m=c.cfg.forms,r,j=c.inputTypes,u={radio:1,checkbox:1};c.addInputType=function(a,c){j[a]=c};var z={customError:!1,typeMismatch:!1,rangeUnderflow:!1,rangeOverflow:!1,stepMismatch:!1,tooLong:!1,patternMismatch:!1,valueMissing:!1,valid:!0},s={valueMissing:function(b,d,f){if(!b.prop("required"))return!1;var g=!1;if(!("type"in f))f.type=(b[0].getAttribute("type")||
b[0].type||"").toLowerCase();if("select"==f.nodeName){if(d=!d)if(!(d=0>b[0].selectedIndex))b=b[0],d="select-one"==b.type&&2>b.size?!!a("> option:first-child",b).prop("selected"):!1;b=d}else b=u[f.type]?"checkbox"==f.type?!b.is(":checked"):!c.modules["form-core"].getGroupElements(b).filter(":checked")[0]:!d;return b},tooLong:function(){return!1},typeMismatch:function(a,c,f){if(""===c||"select"==f.nodeName)return!1;var g=!1;if(!("type"in f))f.type=(a[0].getAttribute("type")||a[0].type||"").toLowerCase();
if(j[f.type]&&j[f.type].mismatch)g=j[f.type].mismatch(c,a);else if("validity"in a[0])g=a[0].validity.typeMismatch;return g},patternMismatch:function(a,d,f){if(""===d||"select"==f.nodeName)return!1;a=a.attr("pattern");if(!a)return!1;try{a=RegExp("^(?:"+a+")$")}catch(g){c.error('invalid pattern value: "'+a+'" | '+g),a=!1}return!a?!1:!a.test(d)}};c.addValidityRule=function(a,c){s[a]=c};a.event.special.invalid={add:function(){a.event.special.invalid.setup.call(this.form||this)},setup:function(){var b=
this.form||this;if(!a.data(b,"invalidEventShim")&&(a(b).data("invalidEventShim",!0).bind("submit",a.event.special.invalid.handler),c.moveToFirstEvent(b,"submit"),c.bugs.bustedValidity&&a.nodeName(b,"form"))){var d=b.getAttribute("novalidate");b.setAttribute("novalidate","novalidate");c.data(b,"bustedNoValidate",null==d?null:d)}},teardown:a.noop,handler:function(b){if(!("submit"!=b.type||b.testedValidity||!b.originalEvent||!a.nodeName(b.target,"form")||a.prop(b.target,"noValidate"))){r=!0;b.testedValidity=
!0;if(!a(b.target).checkValidity())return b.stopImmediatePropagation(),r=!1;r=!1}}};var v=function(b){if(!a.support.submitBubbles&&b&&"object"==typeof b&&!b._submit_attached)a.event.add(b,"submit._submit",function(a){a._submit_bubble=!0}),b._submit_attached=!0};if(!a.support.submitBubbles&&a.event.special.submit)a.event.special.submit.setup=function(){if(a.nodeName(this,"form"))return!1;a.event.add(this,"click._submit keypress._submit",function(b){b=b.target;b=a.nodeName(b,"input")||a.nodeName(b,
"button")?a.prop(b,"form"):void 0;v(b)})};a.event.special.submit=a.event.special.submit||{setup:function(){return!1}};var t=a.event.special.submit.setup;a.extend(a.event.special.submit,{setup:function(){a.nodeName(this,"form")?a(this).bind("invalid",a.noop):a("form",this).bind("invalid",a.noop);return t.apply(this,arguments)}});a(i).bind("invalid",a.noop);c.addInputType("email",{mismatch:function(){var a=m.emailReg||/^[a-zA-Z0-9.!#$%&'*+-\/=?\^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;return function(c){return!a.test(c)}}()});
c.addInputType("url",{mismatch:function(){var a=m.urlReg||/^([a-z]([a-z]|\d|\+|-|\.)*):(\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?((\[(|(v[\da-f]{1,}\.(([a-z]|\d|-|\.|_|~)|[!\$&'\(\)\*\+,;=]|:)+))\])|((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=])*)(:\d*)?)(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*|(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)){0})(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;
return function(c){return!a.test(c)}}()});c.defineNodeNameProperty("input","type",{prop:{get:function(){var a=(this.getAttribute("type")||"").toLowerCase();return c.inputTypes[a]?a:this.type}}});c.defineNodeNamesProperties(["button","fieldset","output"],{checkValidity:{value:function(){return!0}},willValidate:{value:!1},setCustomValidity:{value:a.noop},validity:{writeable:!1,get:function(){return a.extend({},z)}}},"prop");var n=function(b){var d,f=a.prop(b,"validity");if(f)a.data(b,"cachedValidity",
f);else return!0;if(!f.valid){d=a.Event("invalid");var g=a(b).trigger(d);if(r&&!n.unhandledInvalids&&!d.isDefaultPrevented())c.validityAlert.showFor(g),n.unhandledInvalids=!0}a.removeData(b,"cachedValidity");return f.valid},y=/^(?:select|textarea|input)/i;c.defineNodeNameProperty("form","checkValidity",{prop:{value:function(){var b=!0,d=a(a.prop(this,"elements")).filter(function(){if(!y.test(this.nodeName))return!1;var a=c.data(this,"shadowData");return!a||!a.nativeElement||a.nativeElement===this});
n.unhandledInvalids=!1;for(var f=0,g=d.length;f<g;f++)n(d[f])||(b=!1);return b}}});c.defineNodeNamesProperties(["input","textarea","select"],{checkValidity:{value:function(){n.unhandledInvalids=!1;return n(a(this).getNativeElement()[0])}},setCustomValidity:{value:function(b){a.removeData(this,"cachedValidity");c.data(this,"customvalidationMessage",""+b)}},willValidate:{writeable:!1,get:function(){var b={button:1,reset:1,hidden:1,image:1};return function(){var c=a(this).getNativeElement()[0];return!(c.disabled||
c.readOnly||b[c.type])}}()},validity:{writeable:!1,get:function(){var b=a(this).getNativeElement(),d=b[0],f=a.data(d,"cachedValidity");if(f)return f;f=a.extend({},z);if(!a.prop(d,"willValidate")||"submit"==d.type)return f;var g=b.val(),o={nodeName:d.nodeName.toLowerCase()};f.customError=!!c.data(d,"customvalidationMessage");if(f.customError)f.valid=!1;a.each(s,function(a,c){if(c(b,g,o))f[a]=!0,f.valid=!1});a(this).getShadowFocusElement().attr("aria-invalid",f.valid?"false":"true");d=b=null;return f}}},
"prop");c.defineNodeNamesBooleanProperty(["input","textarea","select"],"required",{set:function(b){a(this).getShadowFocusElement().attr("aria-required",!!b+"")},initAttr:!a.browser.msie||7<c.browserVersion});c.reflectProperties(["input"],["pattern"]);if(!("maxLength"in h.createElement("textarea"))){var w=function(){var b,c=0,f=a([]),g=1E9,o=function(){var a=f.prop("value"),b=a.length;b>c&&b>g&&(b=Math.max(c,g),f.prop("value",a.substr(0,b)));c=b},k=function(){clearTimeout(b);f.unbind(".maxlengthconstraint")};
return function(h,x){k();if(-1<x)g=x,c=a.prop(h,"value").length,f=a(h),f.bind("keydown.maxlengthconstraint keypress.maxlengthconstraint paste.maxlengthconstraint cut.maxlengthconstraint",function(){setTimeout(o,0)}),f.bind("keyup.maxlengthconstraint",o),f.bind("blur.maxlengthconstraint",k),b=setInterval(o,200)}}();w.update=function(b,c){a(b).is(":focus")&&(null==c&&(c=a.prop(b,"maxlength")),w(e.target,c))};a(h).bind("focusin",function(b){var c;"TEXTAREA"==b.target.nodeName&&-1<(c=a.prop(b.target,
"maxlength"))&&w(b.target,c)});c.defineNodeNameProperty("textarea","maxlength",{attr:{set:function(a){this.setAttribute("maxlength",""+a);w.update(this)},get:function(){var a=this.getAttribute("maxlength");return null==a?void 0:a}},prop:{set:function(a){if("number"==typeof a||a&&a==1*a){if(0>a)throw"INDEX_SIZE_ERR";a=parseInt(a,10);this.setAttribute("maxlength",a);w.update(this,a)}else this.setAttribute("maxlength","0"),w.update(this,0)},get:function(){var a=this.getAttribute("maxlength");return("number"==
typeof a||a&&a==1*a)&&0<=a?parseInt(a,10):-1}}});c.defineNodeNameProperty("textarea","maxLength",{prop:{set:function(b){a.prop(this,"maxlength",b)},get:function(){return a.prop(this,"maxlength")}}})}var C={submit:1,button:1,image:1},p={};[{name:"enctype",limitedTo:{"application/x-www-form-urlencoded":1,"multipart/form-data":1,"text/plain":1},defaultProp:"application/x-www-form-urlencoded",proptype:"enum"},{name:"method",limitedTo:{get:1,post:1},defaultProp:"get",proptype:"enum"},{name:"action",proptype:"url"},
{name:"target"},{name:"novalidate",propName:"noValidate",proptype:"boolean"}].forEach(function(b){var c="form"+(b.propName||b.name).replace(/^[a-z]/,function(a){return a.toUpperCase()}),f="form"+b.name,g=b.name,o="click.webshimssubmittermutate"+g,k=function(){if("form"in this&&C[this.type]){var k=a.prop(this,"form");if(k){var h=a.attr(this,f);if(null!=h&&(!b.limitedTo||h.toLowerCase()===a.prop(this,c))){var l=a.attr(k,g);a.attr(k,g,h);setTimeout(function(){if(null!=l)a.attr(k,g,l);else try{a(k).removeAttr(g)}catch(b){k.removeAttribute(g)}},
9)}}}};switch(b.proptype){case "url":var i=h.createElement("form");p[c]={prop:{set:function(b){a.attr(this,f,b)},get:function(){var b=a.attr(this,f);if(null==b)return"";i.setAttribute("action",b);return i.action}}};break;case "boolean":p[c]={prop:{set:function(b){b?a.attr(this,"formnovalidate","formnovalidate"):a(this).removeAttr("formnovalidate")},get:function(){return null!=a.attr(this,"formnovalidate")}}};break;case "enum":p[c]={prop:{set:function(b){a.attr(this,f,b)},get:function(){var c=a.attr(this,
f);return!c||(c=c.toLowerCase())&&!b.limitedTo[c]?b.defaultProp:c}}};break;default:p[c]={prop:{set:function(b){a.attr(this,f,b)},get:function(){var b=a.attr(this,f);return null!=b?b:""}}}}p[f]||(p[f]={});p[f].attr={set:function(b){p[f].attr._supset.call(this,b);a(this).unbind(o).bind(o,k)},get:function(){return p[f].attr._supget.call(this)}};p[f].initAttr=!0;p[f].removeAttr={value:function(){a(this).unbind(o);p[f].removeAttr._supvalue.call(this)}}});c.defineNodeNamesProperties(["input","button"],
p);!a.support.getSetAttribute&&null==a("<form novalidate></form>").attr("novalidate")?c.defineNodeNameProperty("form","novalidate",{attr:{set:function(a){this.setAttribute("novalidate",""+a)},get:function(){var a=this.getAttribute("novalidate");return null==a?void 0:a}}}):c.bugs.bustedValidity&&(c.defineNodeNameProperty("form","novalidate",{attr:{set:function(a){c.data(this,"bustedNoValidate",""+a)},get:function(){var a=c.data(this,"bustedNoValidate");return null==a?void 0:a}},removeAttr:{value:function(){c.data(this,
"bustedNoValidate",null)}}}),a.each(["rangeUnderflow","rangeOverflow","stepMismatch"],function(a,c){s[c]=function(a){return(a[0].validity||{})[c]||!1}}));c.defineNodeNameProperty("form","noValidate",{prop:{set:function(b){b?a.attr(this,"novalidate","novalidate"):a(this).removeAttr("novalidate")},get:function(){return null!=a.attr(this,"novalidate")}}});a.browser.webkit&&Modernizr.inputtypes.date&&function(){var b={updateInput:1,input:1},d={date:1,time:1,"datetime-local":1},f={focusout:1,blur:1},g=
{updateInput:1,change:1},o=function(a){var c,d=!0,h=a.prop("value"),l=h,q=function(c){if(a){var f=a.prop("value");f!==h&&(h=f,(!c||!b[c.type])&&a.trigger("input"));c&&g[c.type]&&(l=f);!d&&f!==l&&a.trigger("change")}},o,i=function(b){clearInterval(c);setTimeout(function(){b&&f[b.type]&&(d=!1);a&&(a.unbind("focusout blur",i).unbind("input change updateInput",q),q());a=null},1)};clearInterval(c);c=setInterval(q,160);clearTimeout(o);o=setTimeout(q,9);a.unbind("focusout blur",i).unbind("input change updateInput",
q);a.bind("focusout blur",i).bind("input updateInput change",q)};if(a.event.customEvent)a.event.customEvent.updateInput=!0;(function(){var b=function(b){var c=1,d,f;if("date"==b.type&&(r||!a(b).is(":focus")))if((f=b.value)&&10>f.length&&(f=f.split("-"))&&3==f.length){for(;3>c;c++)if(1==f[c].length)f[c]="0"+f[c];else if(2!=f[c].length){d=!0;break}if(!d)return f=f.join("-"),a.prop(b,"value",f),f}},d,f,g,l;d=c.defineNodeNameProperty("input","checkValidity",{prop:{value:function(){b(this);return d.prop._supvalue.apply(this,
arguments)}}});f=c.defineNodeNameProperty("form","checkValidity",{prop:{value:function(){a("input",this).each(function(){b(this)});return f.prop._supvalue.apply(this,arguments)}}});g=c.defineNodeNameProperty("input","value",{prop:{set:function(){return g.prop._supset.apply(this,arguments)},get:function(){return b(this)||g.prop._supget.apply(this,arguments)}}});l=c.defineNodeNameProperty("input","validity",{prop:{writeable:!1,get:function(){b(this);return l.prop._supget.apply(this,arguments)}}});a(h).bind("change",
function(a){isChangeSubmit=!0;b(a.target);isChangeSubmit=!1})})();a(h).bind("focusin",function(b){b.target&&d[b.target.type]&&!b.target.readOnly&&!b.target.disabled&&o(a(b.target))})}();c.addReady(function(b,c){var f;a("form",b).add(c.filter("form")).bind("invalid",a.noop);try{if(b==h&&!("form"in(h.activeElement||{})))(f=a("input[autofocus], select[autofocus], textarea[autofocus]",b).eq(0).getShadowFocusElement()[0])&&f.offsetHeight&&f.offsetWidth&&f.focus()}catch(g){}});(!Modernizr.formattribute||
!Modernizr.fieldsetdisabled)&&function(){(function(b,c){a.prop=function(d,f,g){var l;if(d&&1==d.nodeType&&g===c&&a.nodeName(d,"form")&&d.id){l=h.getElementsByName(f);if(!l||!l.length)l=h.getElementById(f);if(l&&(l=a(l).filter(function(){return a.prop(this,"form")==d}).get(),l.length))return 1==l.length?l[0]:l}return b.apply(this,arguments)}})(a.prop,void 0);var b=function(b){var c=a.data(b,"webshimsAddedElements");c&&(c.remove(),a.removeData(b,"webshimsAddedElements"))},d=/\r?\n/g,f=/^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,
g=/^(?:select|textarea)/i;Modernizr.formattribute||(c.defineNodeNamesProperty(["input","textarea","select","button","fieldset"],"form",{prop:{get:function(){var b=c.contentAttr(this,"form");b&&(b=h.getElementById(b))&&!a.nodeName(b,"form")&&(b=null);return b||this.form},writeable:!1}}),c.defineNodeNamesProperty(["form"],"elements",{prop:{get:function(){var b=this.id,c=a.makeArray(this.elements);b&&(c=a(c).add('input[form="'+b+'"], select[form="'+b+'"], textarea[form="'+b+'"], button[form="'+b+'"], fieldset[form="'+
b+'"]').not(".webshims-visual-hide > *").get());return c},writeable:!1}}),a(function(){var c=function(a){a.stopPropagation()};a(h).bind("submit",function(c){if(!c.isDefaultPrevented()){var d=c.target;if(c=d.id)b(d),c=a('input[form="'+c+'"], select[form="'+c+'"], textarea[form="'+c+'"]').filter(function(){return!this.disabled&&this.name&&this.form!=d}).clone(),c.length&&(a.data(d,"webshimsAddedElements",a('<div class="webshims-visual-hide" />').append(c).appendTo(d)),setTimeout(function(){b(d)},9)),
c=null}});a(h).bind("click",function(b){if(!b.isDefaultPrevented()&&a(b.target).is('input[type="submit"][form], button[form], input[type="button"][form], input[type="image"][form], input[type="reset"][form]')){var d=a.prop(b.target,"form"),f=b.target.form,g;d&&d!=f&&(g=a(b.target).clone().removeAttr("form").addClass("webshims-visual-hide").bind("click",c).appendTo(d),f&&b.preventDefault(),v(d),g.trigger("click"),setTimeout(function(){g.remove();g=null},9))}})}));Modernizr.fieldsetdisabled||c.defineNodeNamesProperty(["fieldset"],
"elements",{prop:{get:function(){return a("input, select, textarea, button, fieldset",this).get()||[]},writeable:!1}});a.fn.serializeArray=function(){return this.map(function(){var b=a.prop(this,"elements");return b?a.makeArray(b):this}).filter(function(){return this.name&&!this.disabled&&(this.checked||g.test(this.nodeName)||f.test(this.type))}).map(function(b,c){var f=a(this).val();return null==f?null:a.isArray(f)?a.map(f,function(a){return{name:c.name,value:a.replace(d,"\r\n")}}):{name:c.name,
value:f.replace(d,"\r\n")}}).get()}}();(function(){Modernizr.textareaPlaceholder=!!("placeholder"in a("<textarea />")[0]);var b=a.browser.webkit&&Modernizr.textareaPlaceholder&&535>c.browserVersion;if(!Modernizr.input.placeholder||!Modernizr.textareaPlaceholder||b){var d="over"==c.cfg.forms.placeholderType,f=c.cfg.forms.responsivePlaceholder,g=["textarea"];Modernizr.input.placeholder||g.push("input");var h=function(a){try{if(a.setSelectionRange)return a.setSelectionRange(0,0),!0;if(a.createTextRange){var b=
a.createTextRange();b.collapse(!0);b.moveEnd("character",0);b.moveStart("character",0);b.select();return!0}}catch(c){}},k=function(b,c,f,g){!1===f&&(f=a.prop(b,"value"));if(!d&&"password"!=b.type){if(!f&&g&&h(b)){var i=setTimeout(function(){h(b)},9);a(b).unbind(".placeholderremove").bind("keydown.placeholderremove keypress.placeholderremove paste.placeholderremove input.placeholderremove",function(d){if(!d||!(17==d.keyCode||16==d.keyCode))b.value=a.prop(b,"value"),c.box.removeClass("placeholder-visible"),
clearTimeout(i),a(b).unbind(".placeholderremove")}).bind("mousedown.placeholderremove drag.placeholderremove select.placeholderremove",function(){h(b);clearTimeout(i);i=setTimeout(function(){h(b)},9)}).bind("blur.placeholderremove",function(){clearTimeout(i);a(b).unbind(".placeholderremove")});return}b.value=f}else if(!f&&g){a(b).unbind(".placeholderremove").bind("keydown.placeholderremove keypress.placeholderremove paste.placeholderremove input.placeholderremove",function(d){if(!d||!(17==d.keyCode||
16==d.keyCode))c.box.removeClass("placeholder-visible"),a(b).unbind(".placeholderremove")}).bind("blur.placeholderremove",function(){a(b).unbind(".placeholderremove")});return}c.box.removeClass("placeholder-visible")},j=function(b,c,f,g,h){if(!g&&(g=a.data(b,"placeHolder"),!g))return;a(b).unbind(".placeholderremove");if("focus"==h||!h&&a(b).is(":focus"))("password"==b.type||d||a(b).hasClass("placeholder-visible"))&&k(b,g,"",!0);else if(!1===c&&(c=a.prop(b,"value")),c)k(b,g,c);else if(!1===f&&(f=a.attr(b,
"placeholder")||""),f&&!c){c=g;!1===f&&(f=a.prop(b,"placeholder"));if(!d&&"password"!=b.type)b.value=f;c.box.addClass("placeholder-visible")}else k(b,g,c)},m=function(b){var b=a(b),c=b.prop("id"),d=!(!b.prop("title")&&!b.attr("aria-labelledby"));!d&&c&&(d=!!a('label[for="'+c+'"]',b[0].form)[0]);d||(c||(c=a.webshims.getID(b)),d=!!a("label #"+c)[0]);return a(d?'<span class="placeholder-text"></span>':'<label for="'+c+'" class="placeholder-text"></label>')},n=function(){var b={text:1,search:1,url:1,
email:1,password:1,tel:1};return{create:function(b){var c=a.data(b,"placeHolder"),g;if(c)return c;c=a.data(b,"placeHolder",{});a(b).bind("focus.placeholder blur.placeholder",function(a){j(this,!1,!1,c,a.type);c.box["focus"==a.type?"addClass":"removeClass"]("placeholder-focused")});(g=a.prop(b,"form"))&&a(g).bind("reset.placeholder",function(a){setTimeout(function(){j(b,!1,!1,c,a.type)},0)});if("password"==b.type||d)c.text=m(b),c.box=f||a(b).is(".responsive-width")||-1!=(b.currentStyle||{width:""}).width.indexOf("%")?
c.text:a(b).wrap('<span class="placeholder-box placeholder-box-'+(b.nodeName||"").toLowerCase()+" placeholder-box-"+a.css(b,"float")+'" />').parent(),c.text.insertAfter(b).bind("mousedown.placeholder",function(){j(this,!1,!1,c,"focus");try{setTimeout(function(){b.focus()},0)}catch(a){}return!1}),a.each(["lineHeight","fontSize","fontFamily","fontWeight"],function(d,f){var g=a.css(b,f);c.text.css(f)!=g&&c.text.css(f,g)}),a.each(["Left","Top"],function(d,f){var g=(parseInt(a.css(b,"padding"+f),10)||
0)+Math.max(parseInt(a.css(b,"margin"+f),10)||0,0)+(parseInt(a.css(b,"border"+f+"Width"),10)||0);c.text.css("padding"+f,g)}),a(b).bind("updateshadowdom",function(){var d,f;((f=b.offsetWidth)||(d=b.offsetHeight))&&c.text.css({width:f,height:d}).css(a(b).position())}).triggerHandler("updateshadowdom");else{var h=function(d){a(b).hasClass("placeholder-visible")&&(k(b,c,""),d&&"submit"==d.type&&setTimeout(function(){d.isDefaultPrevented()&&j(b,!1,!1,c)},9))};a(i).bind("beforeunload",h);c.box=a(b);g&&
a(g).submit(h)}return c},update:function(d,f){var g=(a.attr(d,"type")||a.prop(d,"type")||"").toLowerCase();!b[g]&&!a.nodeName(d,"textarea")?(c.error('placeholder not allowed on input[type="'+g+'"]'),"date"==g&&c.error('but you can use data-placeholder for input[type="date"]')):(g=n.create(d),g.text&&g.text.text(f),j(d,!1,f,g))}}}();a.webshims.publicMethods={pHolder:n};g.forEach(function(a){c.defineNodeNameProperty(a,"placeholder",{attr:{set:function(a){b?(c.data(this,"textareaPlaceholder",a),this.placeholder=
""):c.contentAttr(this,"placeholder",a);n.update(this,a)},get:function(){return(b?c.data(this,"textareaPlaceholder"):"")||c.contentAttr(this,"placeholder")}},reflect:!0,initAttr:!0})});g.forEach(function(d){var f={},g;["attr","prop"].forEach(function(d){f[d]={set:function(f){var h;b&&(h=c.data(this,"textareaPlaceholder"));h||(h=c.contentAttr(this,"placeholder"));a.removeData(this,"cachedValidity");var i=g[d]._supset.call(this,f);h&&"value"in this&&j(this,f,h);return i},get:function(){return a(this).hasClass("placeholder-visible")?
"":g[d]._supget.call(this)}}});g=c.defineNodeNameProperty(d,"value",f)})}})();(function(){if(!("value"in h.createElement("output"))){c.defineNodeNameProperty("output","value",{prop:{set:function(c){var f=a.data(this,"outputShim");f||(f=b(this));f(c)},get:function(){return c.contentAttr(this,"value")||a(this).text()||""}}});c.onNodeNamesPropertyModify("input","value",function(b,c,g){"removeAttr"!=g&&(c=a.data(this,"outputShim"))&&c(b)});var b=function(b){if(!b.getAttribute("aria-live")){var b=a(b),
f=(b.text()||"").trim(),g=b.attr("id"),i=b.attr("for"),j=a('<input class="output-shim" type="text" disabled name="'+(b.attr("name")||"")+'" value="'+f+'" style="display: none !important;" />').insertAfter(b),m=j[0].form||h,n=function(a){j[0].value=a;a=j[0].value;b.text(a);c.contentAttr(b[0],"value",a)};b[0].defaultValue=f;c.contentAttr(b[0],"value",f);b.attr({"aria-live":"polite"});g&&(j.attr("id",g),b.attr("aria-labelledby",c.getID(a('label[for="'+g+'"]',m))));i&&(g=c.getID(b),i.split(" ").forEach(function(a){(a=
h.getElementById(a))&&a.setAttribute("aria-controls",g)}));b.data("outputShim",n);j.data("outputShim",n);return n}};c.addReady(function(c,f){a("output",c).add(f.filter("output")).each(function(){b(this)})});(function(){var b={updateInput:1,input:1},f={radio:1,checkbox:1,submit:1,button:1,image:1,reset:1,file:1,color:1},g=function(a){var f,g=a.prop("value"),h=function(f){if(a){var h=a.prop("value");h!==g&&(g=h,(!f||!b[f.type])&&c.triggerInlineForm&&c.triggerInlineForm(a[0],"input"))}},i,j=function(){clearTimeout(i);
i=setTimeout(h,9)},m=function(){a.unbind("focusout",m).unbind("keyup keypress keydown paste cut",j).unbind("input change updateInput",h);clearInterval(f);setTimeout(function(){h();a=null},1)};clearInterval(f);f=setInterval(h,99);j();a.bind("keyup keypress keydown paste cut",j).bind("focusout",m).bind("input updateInput change",h)};if(a.event.customEvent)a.event.customEvent.updateInput=!0;a(h).bind("focusin",function(b){b.target&&b.target.type&&!b.target.readOnly&&!b.target.disabled&&"input"==(b.target.nodeName||
"").toLowerCase()&&!f[b.target.type]&&g(a(b.target))})})()}})()});