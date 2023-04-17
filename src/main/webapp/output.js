function output(){
    var content = "What's up , hello world";
    // any kind of extension (.txt,.cpp,.cs,.bat)
    var filename = "hello.txt";

    var blob = new Blob([content], {
        type: "text/plain;charset=utf-8"
    });

    saveAs(blob, filename);
};
