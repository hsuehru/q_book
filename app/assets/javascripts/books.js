$(document).ready(function() {
  $('.category_id').change( function(){
    var category_id = $(".category_id").val();
    $.ajax({
      url: "http://120.105.81.17:3000/book/get_category_item/" + category_id,
      type: "GET",
      success: function(data){
        if(data["result"] == "false"){
          alert(data["error_message"]);
        }
        else{
          $(".category_item_id").empty();
          for(var i =0; i < data.length; i++){
            $(".category_item_id").append(
              new Option(data[i]["name"],data[i]["id"]));
          }
        }
      }
      
    })
  });
});
