jQuery.webshims.register("mediaelement-swf",function(c,f,m,u,s,j){var h=f.mediaelement,A=m.swfobject,v=Modernizr.audio&&Modernizr.video,B=A.hasFlashPlayerVersion("9.0.115"),t=0,m={paused:!0,ended:!1,currentSrc:"",duration:m.NaN,readyState:0,networkState:0,videoHeight:0,videoWidth:0,error:null,buffered:{start:function(a){if(a)f.error("buffered index size error");else return 0},end:function(a){if(a)f.error("buffered index size error");else return 0},length:0}},J=Object.keys(m),C={currentTime:0,volume:1,
muted:!1};Object.keys(C);var D=c.extend({isActive:"html5",activating:"html5",wasSwfReady:!1,_bufferedEnd:0,_bufferedStart:0,_metadata:!1,_durationCalcs:-1,_callMeta:!1,currentTime:0,_ppFlag:s},m,C),E=/^jwplayer-/,l=function(a){if(a=u.getElementById(a.replace(E,"")))return a=f.data(a,"mediaelement"),"third"==a.isActive?a:null},n=function(a){return(a=f.data(a,"mediaelement"))&&"third"==a.isActive?a:null},g=function(a,b){b=c.Event(b);b.preventDefault();c.event.trigger(b,s,a)},K=j.playerPath||f.cfg.basePath+
"jwplayer/"+(j.playerName||"player.swf"),F=j.pluginPath||f.cfg.basePath+"swf/jwwebshims.swf";f.extendUNDEFProp(j.jwParams,{allowscriptaccess:"always",allowfullscreen:"true",wmode:"transparent"});f.extendUNDEFProp(j.jwVars,{screencolor:"ffffffff"});f.extendUNDEFProp(j.jwAttrs,{bgcolor:"#000000"});var x=function(a,b){var d=a.duration;if(!(d&&0<a._durationCalcs)){try{if(a.duration=a.jwapi.getPlaylist()[0].duration,!a.duration||0>=a.duration||a.duration===a._lastDuration)a.duration=d}catch(e){}a.duration&&
a.duration!=a._lastDuration?(g(a._elem,"durationchange"),("audio"==a._elemNodeName||a._callMeta)&&h.jwEvents.Model.META(c.extend({duration:a.duration},b),a),a._durationCalcs--):a._durationCalcs++}},k=function(a,b){3>a&&clearTimeout(b._canplaythroughTimer);if(3<=a&&3>b.readyState)b.readyState=a,g(b._elem,"canplay"),clearTimeout(b._canplaythroughTimer),b._canplaythroughTimer=setTimeout(function(){k(4,b)},4E3);if(4<=a&&4>b.readyState)b.readyState=a,g(b._elem,"canplaythrough");b.readyState=a};c.extend(c.event.customEvent,
{updatemediaelementdimensions:!0,flashblocker:!0,swfstageresize:!0,mediaelementapichange:!0});h.jwEvents={View:{PLAY:function(a){var b=l(a.id);if(b&&!b.stopPlayPause&&(b._ppFlag=!0,b.paused==a.state)){b.paused=!a.state;if(b.ended)b.ended=!1;g(b._elem,a.state?"play":"pause")}}},Model:{BUFFER:function(a){var b=l(a.id);if(b&&"percentage"in a&&b._bufferedEnd!=a.percentage){b.networkState=100==a.percentage?1:2;(isNaN(b.duration)||5<a.percentage&&25>a.percentage||100===a.percentage)&&x(b,a);if(b.ended)b.ended=
!1;if(b.duration){2<a.percentage&&20>a.percentage?k(3,b):20<a.percentage&&k(4,b);if(b._bufferedEnd&&b._bufferedEnd>a.percentage)b._bufferedStart=b.currentTime||0;b._bufferedEnd=a.percentage;b.buffered.length=1;if(100==a.percentage)b.networkState=1,k(4,b);c.event.trigger("progress",s,b._elem,!0)}}},META:function(a,b){if(b=b&&b.networkState?b:l(a.id))if("duration"in a){if(!b._metadata||!((!a.height||b.videoHeight==a.height)&&a.duration===b.duration)){b._metadata=!0;var d=b.duration;if(a.duration)b.duration=
a.duration;b._lastDuration=b.duration;if(a.height||a.width)b.videoHeight=a.height||0,b.videoWidth=a.width||0;if(!b.networkState)b.networkState=2;1>b.readyState&&k(1,b);b.duration&&d!==b.duration&&g(b._elem,"durationchange");g(b._elem,"loadedmetadata")}}else b._callMeta=!0},TIME:function(a){var b=l(a.id);if(b&&b.currentTime!==a.position){b.currentTime=a.position;b.duration&&b.duration<b.currentTime&&x(b,a);2>b.readyState&&k(2,b);if(b.ended)b.ended=!1;g(b._elem,"timeupdate")}},STATE:function(a){var b=
l(a.id);if(b)switch(a.newstate){case "BUFFERING":if(b.ended)b.ended=!1;k(1,b);g(b._elem,"waiting");break;case "PLAYING":b.paused=!1;b._ppFlag=!0;b.duration||x(b,a);3>b.readyState&&k(3,b);if(b.ended)b.ended=!1;g(b._elem,"playing");break;case "PAUSED":if(!b.paused&&!b.stopPlayPause)b.paused=!0,b._ppFlag=!0,g(b._elem,"pause");break;case "COMPLETED":4>b.readyState&&k(4,b),b.ended=!0,g(b._elem,"ended")}}},Controller:{ERROR:function(a){var b=l(a.id);b&&h.setError(b._elem,a.message)},SEEK:function(a){var b=
l(a.id);if(b){if(b.ended)b.ended=!1;if(b.paused)try{b.jwapi.sendEvent("play","false")}catch(d){}if(b.currentTime!=a.position)b.currentTime=a.position,g(b._elem,"timeupdate")}},VOLUME:function(a){var b=l(a.id);if(b&&(a=a.percentage/100,b.volume!=a))b.volume=a,g(b._elem,"volumechange")},MUTE:function(a){if(!a.state){var b=l(a.id);if(b&&b.muted!=a.state)b.muted=a.state,g(b._elem,"volumechange")}}}};var L=function(a){var b=!0;c.each(h.jwEvents,function(d,e){c.each(e,function(c){try{a.jwapi["add"+d+"Listener"](c,
"jQuery.webshims.mediaelement.jwEvents."+d+"."+c)}catch(e){return b=!1}})});return b},M=function(a){var b=a.actionQueue.length,d=0,c;if(b&&"third"==a.isActive)for(;a.actionQueue.length&&b>d;)d++,c=a.actionQueue.shift(),a.jwapi[c.fn].apply(a.jwapi,c.args);if(a.actionQueue.length)a.actionQueue=[]},G=function(a){a&&(a._ppFlag===s&&c.prop(a._elem,"autoplay")||!a.paused)&&setTimeout(function(){if("third"==a.isActive&&(a._ppFlag===s||!a.paused))try{c(a._elem).play()}catch(b){}},1)},N=function(a){if(a&&
"video"==a._elemNodeName){var b,d,e,f,o,i,g,j,h=function(p,q){if(q&&p&&!(1>q||1>p||"third"!=a.isActive))if(b&&(b.remove(),b=!1),f=p,o=q,clearTimeout(g),d="auto"==a._elem.style.width,e="auto"==a._elem.style.height,d||e){i=i||c(a._elem).getShadowElement();var h;d&&!e?(h=i.height(),p*=h/q,q=h):!d&&e&&(h=i.width(),q*=h/p,p=h);j=!0;setTimeout(function(){j=!1},9);i.css({width:p,height:q})}},l=function(){if(!("third"!=a.isActive||c.prop(a._elem,"readyState")&&c.prop(this,"videoWidth"))){var i=c.prop(a._elem,
"poster");if(i&&(d="auto"==a._elem.style.width,e="auto"==a._elem.style.height,d||e))b&&(b.remove(),b=!1),b=c('<img style="position: absolute; height: auto; width: auto; top: 0px; left: 0px; visibility: hidden;" />'),b.bind("load error alreadycomplete",function(){clearTimeout(g);var a=this,d=a.naturalWidth||a.width||a.offsetWidth,i=a.naturalHeight||a.height||a.offsetHeight;i&&d?(h(d,i),a=null):setTimeout(function(){d=a.naturalWidth||a.width||a.offsetWidth;i=a.naturalHeight||a.height||a.offsetHeight;
h(d,i);b&&(b.remove(),b=!1);a=null},9);c(this).unbind()}).prop("src",i).appendTo("body").each(function(){this.complete||this.error?c(this).triggerHandler("alreadycomplete"):(clearTimeout(g),g=setTimeout(function(){c(a._elem).triggerHandler("error")},9999))})}};c(a._elem).bind("loadedmetadata",function(){h(c.prop(this,"videoWidth"),c.prop(this,"videoHeight"))}).bind("emptied",l).bind("swfstageresize updatemediaelementdimensions",function(){j||h(f,o)}).bind("emptied",function(){f=void 0;o=void 0}).triggerHandler("swfstageresize");
l();c.prop(a._elem,"readyState")&&h(c.prop(a._elem,"videoWidth"),c.prop(a._elem,"videoHeight"))}};h.playerResize=function(a){a&&(a=u.getElementById(a.replace(E,"")))&&c(a).triggerHandler("swfstageresize")};c(u).bind("emptied",function(a){a=n(a.target);G(a)});var w;h.jwPlayerReady=function(a){var b=l(a.id),d=0,e=function(){if(!(9<d))if(d++,L(b)){if(b.wasSwfReady)c(b._elem).mediaLoad();else{var g=parseFloat(a.version,10);(5.1>g||6<=g)&&f.warn("mediaelement-swf is only testet with jwplayer 5.6+")}b.wasSwfReady=
!0;b.tryedReframeing=0;M(b);G(b)}else clearTimeout(b.reframeTimer),b.reframeTimer=setTimeout(e,9*d),2<d&&9>b.tryedReframeing&&(b.tryedReframeing++,b.shadowElem.css({overflow:"visible"}),setTimeout(function(){b.shadowElem.css({overflow:"hidden"})},16))};if(b&&b.jwapi){if(!b.tryedReframeing)b.tryedReframeing=0;clearTimeout(w);b.jwData=a;b.shadowElem.removeClass("flashblocker-assumed");c.prop(b._elem,"volume",b.volume);c.prop(b._elem,"muted",b.muted);e()}};var y=c.noop;if(v){var O={play:1,playing:1},
H="play,pause,playing,canplay,progress,waiting,ended,loadedmetadata,durationchange,emptied".split(","),I=H.map(function(a){return a+".webshimspolyfill"}).join(" "),P=function(a){var b=f.data(a.target,"mediaelement");b&&(a.originalEvent&&a.originalEvent.type===a.type)==("third"==b.activating)&&(a.stopImmediatePropagation(),O[a.type]&&b.isActive!=b.activating&&c(a.target).pause())},y=function(a){c(a).unbind(I).bind(I,P);H.forEach(function(b){f.moveToFirstEvent(a,b)})};y(u)}h.setActive=function(a,b,
d){d||(d=f.data(a,"mediaelement"));if(d&&d.isActive!=b){"html5"!=b&&"third"!=b&&f.warn("wrong type for mediaelement activating: "+b);var e=f.data(a,"shadowData");d.activating=b;c(a).pause();d.isActive=b;"third"==b?(e.shadowElement=e.shadowFocusElement=d.shadowElem[0],c(a).addClass("swf-api-active nonnative-api-active").hide().getShadowElement().show()):(c(a).removeClass("swf-api-active nonnative-api-active").show().getShadowElement().hide(),e.shadowElement=e.shadowFocusElement=!1);c(a).trigger("mediaelementapichange")}};
var Q=function(){var a="_bufferedEnd,_bufferedStart,_metadata,_ppFlag,currentSrc,currentTime,duration,ended,networkState,paused,videoHeight,videoWidth,_callMeta,_durationCalcs".split(","),b=a.length;return function(d){if(d){var c=b,f=d.networkState;for(k(0,d);--c;)delete d[a[c]];d.actionQueue=[];d.buffered.length=0;f&&g(d._elem,"emptied")}}}(),z=function(a,b){var d=a._elem,e=a.shadowElem;c(d)[b?"addClass":"removeClass"]("webshims-controls");"audio"==a._elemNodeName&&!b?e.css({width:0,height:0}):e.css({width:d.style.width||
c(d).width(),height:d.style.height||c(d).height()})};h.createSWF=function(a,b,d){if(B){1>t?t=1:t++;var e=c.extend({},j.jwVars,{image:c.prop(a,"poster")||"",file:b.srcProp}),g=c(a).data("jwvars")||{};d||(d=f.data(a,"mediaelement"));if(d&&d.swfCreated)h.setActive(a,"third",d),Q(d),d.currentSrc=b.srcProp,c.extend(e,g),j.changeJW(e,a,b,d,"load"),r(a,"sendEvent",["LOAD",e]);else{var o=c.prop(a,"controls"),i="jwplayer-"+f.getID(a),l=c.extend({},j.jwParams,c(a).data("jwparams")),k=a.nodeName.toLowerCase(),
n=c.extend({},j.jwAttrs,{name:i,id:i},c(a).data("jwattrs")),m=c('<div class="polyfill-'+k+' polyfill-mediaelement" id="wrapper-'+i+'"><div id="'+i+'"></div>').css({position:"relative",overflow:"hidden"}),d=f.data(a,"mediaelement",f.objectCreate(D,{actionQueue:{value:[]},shadowElem:{value:m},_elemNodeName:{value:k},_elem:{value:a},currentSrc:{value:b.srcProp},swfCreated:{value:!0},buffered:{value:{start:function(a){if(a>=d.buffered.length)f.error("buffered index size error");else return 0},end:function(a){if(a>=
d.buffered.length)f.error("buffered index size error");else return(d.duration-d._bufferedStart)*d._bufferedEnd/100+d._bufferedStart},length:0}}}));z(d,o);m.insertBefore(a);v&&c.extend(d,{volume:c.prop(a,"volume"),muted:c.prop(a,"muted")});c.extend(e,{id:i,controlbar:o?j.jwVars.controlbar||("video"==k?"over":"bottom"):"video"==k?"none":"bottom",icons:""+(o&&"video"==k)},g,{playerready:"jQuery.webshims.mediaelement.jwPlayerReady"});e.plugins=e.plugins?e.plugins+(","+F):F;f.addShadowDom(a,m);y(a);h.setActive(a,
"third",d);j.changeJW(e,a,b,d,"embed");c(a).bind("updatemediaelementdimensions updateshadowdom",function(){z(d,c.prop(a,"controls"))});N(d);A.embedSWF(K,i,"100%","100%","9.0.0",!1,e,l,n,function(b){if(b.success)d.jwapi=b.ref,o||c(b.ref).attr("tabindex","-1").css("outline","none"),setTimeout(function(){if(!b.ref.parentNode&&m[0].parentNode||"none"==b.ref.style.display)m.addClass("flashblocker-assumed"),c(a).trigger("flashblocker"),f.warn("flashblocker assumed");c(b.ref).css({minHeight:"2px",minWidth:"2px",
display:"block"})},9),w||(clearTimeout(w),w=setTimeout(function(){var a=c(b.ref);1<a[0].offsetWidth&&1<a[0].offsetHeight&&0===location.protocol.indexOf("file:")?f.error("Add your local development-directory to the local-trusted security sandbox:  http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html"):(2>a[0].offsetWidth||2>a[0].offsetHeight)&&f.info("JS-SWF connection can't be established on hidden or unconnected flash objects")},8E3))})}}else setTimeout(function(){c(a).mediaLoad()},
1)};var r=function(a,b,d,c){return(c=c||n(a))?(c.jwapi&&c.jwapi[b]?c.jwapi[b].apply(c.jwapi,d||[]):(c.actionQueue.push({fn:b,args:d}),10<c.actionQueue.length&&setTimeout(function(){5<c.actionQueue.length&&c.actionQueue.shift()},99)),c):!1};["audio","video"].forEach(function(a){var b={},d,e=function(c){"audio"==a&&("videoHeight"==c||"videoWidth"==c)||(b[c]={get:function(){var a=n(this);return a?a[c]:v&&d[c].prop._supget?d[c].prop._supget.apply(this):D[c]},writeable:!1})},h=function(a,c){e(a);delete b[a].writeable;
b[a].set=c};h("volume",function(a){var b=n(this);if(b){if(a*=100,!isNaN(a)){var c=b.muted;(0>a||100<a)&&f.error("volume greater or less than allowed "+a/100);r(this,"sendEvent",["VOLUME",a],b);if(c)try{b.jwapi.sendEvent("mute","true")}catch(e){}a/=100;if(!(b.volume==a||"third"!=b.isActive))b.volume=a,g(b._elem,"volumechange")}}else if(d.volume.prop._supset)return d.volume.prop._supset.apply(this,arguments)});h("muted",function(a){var b=n(this);if(b){if(a=!!a,r(this,"sendEvent",["mute",""+a],b),!(b.muted==
a||"third"!=b.isActive))b.muted=a,g(b._elem,"volumechange")}else if(d.muted.prop._supset)return d.muted.prop._supset.apply(this,arguments)});h("currentTime",function(a){var b=n(this);if(b){if(a*=1,!isNaN(a)){if(b.paused)clearTimeout(b.stopPlayPause),b.stopPlayPause=setTimeout(function(){b.paused=!0;b.stopPlayPause=!1},50);r(this,"sendEvent",["SEEK",""+a],b);if(b.paused){if(0<b.readyState)b.currentTime=a,g(b._elem,"timeupdate");try{b.jwapi.sendEvent("play","false")}catch(c){}}}}else if(d.currentTime.prop._supset)return d.currentTime.prop._supset.apply(this,
arguments)});["play","pause"].forEach(function(a){b[a]={value:function(){var b=n(this);if(b)b.stopPlayPause&&clearTimeout(b.stopPlayPause),r(this,"sendEvent",["play","play"==a],b),setTimeout(function(){if("third"==b.isActive&&(b._ppFlag=!0,b.paused!=("play"!=a)))b.paused="play"!=a,g(b._elem,a)},1);else if(d[a].prop._supvalue)return d[a].prop._supvalue.apply(this,arguments)}}});J.forEach(e);f.onNodeNamesPropertyModify(a,"controls",function(b,d){var e=n(this);c(this)[d?"addClass":"removeClass"]("webshims-controls");
if(e){try{r(this,d?"showControls":"hideControls",[a],e)}catch(g){f.warn("you need to generate a crossdomain.xml")}"audio"==a&&z(e,d);c(e.jwapi).attr("tabindex",d?"0":"-1")}});d=f.defineNodeNameProperties(a,b,"prop")});if(B){var R=c.cleanData,S=c.browser.msie&&9>f.browserVersion,T={object:1,OBJECT:1};c.cleanData=function(a){var b,c,e;if(a&&(c=a.length)&&t)for(b=0;b<c;b++)if(T[a[b].nodeName]){if("sendEvent"in a[b]){t--;try{a[b].sendEvent("play",!1)}catch(f){}}if(S)try{for(e in a[b])"function"==typeof a[b][e]&&
(a[b][e]=null)}catch(g){}}return R.apply(this,arguments)}}v||(["poster","src"].forEach(function(a){f.defineNodeNamesProperty("src"==a?["audio","video","source"]:["video"],a,{reflect:!0,propType:"src"})}),["autoplay","controls"].forEach(function(a){f.defineNodeNamesBooleanProperty(["audio","video"],a)}),f.defineNodeNamesProperties(["audio","video"],{HAVE_CURRENT_DATA:{value:2},HAVE_ENOUGH_DATA:{value:4},HAVE_FUTURE_DATA:{value:3},HAVE_METADATA:{value:1},HAVE_NOTHING:{value:0},NETWORK_EMPTY:{value:0},
NETWORK_IDLE:{value:1},NETWORK_LOADING:{value:2},NETWORK_NO_SOURCE:{value:3}},"prop"))});
