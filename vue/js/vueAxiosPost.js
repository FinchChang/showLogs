// 將 axios 指定給 $http 屬性

var $ApiURL = 'jsp/axiosDataGet.jsp';
Vue.prototype.$http = axios;
var dataLength = 0;
var dataCounter = 0;
var scrollEnd = true;
var app = new Vue({
    el: '#app',
    data: {
        message: '',
        memo: '',
        Line:0,
        time: 0,
        scrollEndName: 'Stop'
    },
    mounted: function counter() {
        interval = setInterval(() => {
            if (this.time === 0) {
                this.get_store_info();
            }
            if(this.time > 0){
                this.time = this.time - 1;
            }else{
                this.time = "waiting for data";
            }
        }, 1000)
    },
    methods: {
        get_store_info: function() {
            var self = this;
            let fmdata = 'dataLength='+dataLength+"&dataCounter="+dataCounter;
            this.$http.post($ApiURL,fmdata)
                .then((result) => {
                    console.log(result)
                    if(result.data.line != undefined){
                        dataCounter = result.data.line;
                        this.Line = result.data.line;
                    }
                    if(result.data.size != undefined){
                        dataLength=result.data.size;
                    }
                    if( result.data.content != undefined){
                        if(this.message == ''){
                            this.message = result.data.content;
                        }else{
                            this.message += result.data.content;
                        }
                    }
                    if( result.data.size === 1){
                        this.memo = 'The data is loading, please wait..., the scroll will move to bottom when the data loading is completed.';
                        this.time = 0;
                    }else{
                        this.memo ='';
                        this.time = 5;
                        this.scrollToEnd();
                    }
                })
                .catch(function(error) {
                    console.error(error);
                });
        },
        scrollToEnd: function() {
          //window.scrollTo(0,document.querySelector(".logBody").scrollHeight);
          //document.body.scrollTop = document.body.scrollHeight;
          if(scrollEnd){
            let nowHeight = Math.max(document.documentElement.clientHeight,document.documentElement.scrollHeight);
            window.scrollTo(0,nowHeight);
          }

        },
        scrollStatusChange: function(){
            if(this.scrollEnd){
                this.scrollEnd = false;
                this.scrollEndName = 'Start';
            }else{
                this.scrollEnd = true;
                this.scrollEndName = 'Stop';
            }
        },
    }
});
