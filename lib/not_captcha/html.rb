module NotCaptcha
  module HTML
    def self.generate_captcha hashes, time, size, anglescnt=8
      angl2 = (anglescnt-1)*10
      notcaptcha_url = '/not_captcha'
      images = [
        {name: :imgone, hash: hashes[0], num: 1},
        {name: :imgtwo, hash: hashes[1], num: 2},
        {name: :imgthree, hash: hashes[2], num: 3}
      ]

      options = (1..anglescnt).to_a.map{|i| "<option value=#{(i-1)}>#{i}</option>" }.join
%@
<!-- NotCaptcha HEAD start -->
<script type="text/javascript" src="/assets/not_captcha/trackbar.js"></script>
<style>
#captchaImgDiv img {padding:0;margin:0;border:0;display:inline;float:none}
#captchaImgDiv td {padding:0;margin:0;border:0}
#captchaImgDiv div {padding:0;margin:0;border:0}
#captchaImgDiv span {padding:0;margin:0;border:0}
.imgunit {
  width: #{size}px;
  height: #{size}px;
  overflow:hidden;
  padding:0;
  margin:0;
  margin-left: #{(angl2-size)/2}px;
  position: relative; /* IE fix */
}
.imgunit img {padding:0;margin:0;position:relative}
.captchablock {width: #{angl2+4}px; float:left; padding:2px; margin:0;}
.captchablock img {padding:0;margin:0;border:0;display: inline;}
/* Reset */
table.trackbar div, table.trackbar td {margin:0; padding:0;}
table.trackbar {border-collapse:collapse;border-spacing:0;}
table.trackbar img{border:0;display: inline;}

/* Styles */
table.trackbar {width: #{angl2}px; background:repeat-x url(/assets/not_captcha/imgtrackbar/b_bg_on.gif) top left;}
table.trackbar .l {width:1%; text-align: right; font-size: 1px; background:repeat-x url(/assets/not_captcha/imgtrackbar/b_bg_off.gif) top left;}
table.trackbar .l div {position:relative; width:0; text-align: right; z-index:500; white-space:nowrap;}
table.trackbar .l div img {cursor:pointer;}
table.trackbar .l div span {position:absolute;top:-12px; right:6px; z-index:1000; font:11px tahoma; color:#000;}
table.trackbar .l div span.limit {text-align:left; position:absolute;top:-12px; right:100%; z-index:100; font:11px tahoma; color:#D0D0D0;}
table.trackbar .r {position:relative; width:1%; text-align: left; font-size: 1px; background:repeat-x url(/assets/not_captcha/imgtrackbar/b_bg_off.gif) top right; cursor:default;}
table.trackbar .r div {position:relative; width:0; text-align: left; z-index:500; white-space:nowrap;}
table.trackbar .r div img {cursor:pointer;}
table.trackbar .r div span {position:absolute;top:-12px; left:6px; z-index:1000; font:11px tahoma; color:#000;}
table.trackbar .r div span.limit {position:absolute;top:-12px; left:100%; z-index:100; font:11px tahoma; color:#D0D0D0;}
table.trackbar .c {font-size:1px; width:100%;}

#not_captcha .make_vertical,
#not_captcha .move_slider {clear:both;}
#not_captcha .captchas {clear:both}
#not_captcha .refresh_images {cursor:pointer; padding:2px; border-bottom: 1px dashed;}
#not_captcha .left-begun,
#not_captcha .right-begun {width: 5px;height: 17px;}
</style>
<!-- NotCaptcha HEAD end -->

<!-- NotCaptcha FORM start -->
<div id="not_captcha">
<small class="before_send">#{I18n.t('not_captcha.before_you_submit')}</small><br />
<div class="make_vertical"><small>#{I18n.t('not_captcha.make_image_vertical')} <img src="/assets/not_captcha/vertical_sign.png" alt="^" border="0" /></small></div>
<script language="javascript">
  document.write('<div class="captchas">');
  function setCaptchaValue(id, val) {
    document.getElementById(id+"Field").value = val/10;
    val = -val/10*#{size} - (val/10);
    document.getElementById(id+"Pict").style.left = val + "px";
  }
  
  function refresh_security_image() {
    var blank = "/assets/not_captcha/blank.gif";

    for(var imdx in image_list){
      document.getElementById(image_list[imdx].name + "Pict").src = blank;
      var new_url = "#{notcaptcha_url}/"+image_list[imdx].hash+"?t=#{time}" + Math.floor(Math.random() * 1000);
      document.getElementById(image_list[imdx].name + "Pict").src = new_url;
    }
  }

  // mobile start
  function setCaptchaValueMobile(id) {
    val = document.getElementById(id+"Field").value;
    val++;
    if (val >= #{anglescnt}) {
      val = 0;
    }
    document.getElementById(id+"Field").value = val;
    val *= 10;
    val = -val/10*#{size} - (val/10);
    document.getElementById(id+"Pict").style.left = val + "px";
  }
  // mobile end

  var image_list = #{images.to_json};

  for(var imdx in image_list){
    document.write('<div class="captchablock">');
    document.write('<div id="'+image_list[imdx].name+'Unit" class="imgunit"><img id="'+image_list[imdx].name+'Pict" src="#{notcaptcha_url}/'+image_list[imdx].hash+'?t=#{time}" onclick = "setCaptchaValueMobile(\\''+image_list[imdx].name+'\\')" /></div>');
    document.write('<input type="hidden" id="'+image_list[imdx].name+'Field" name="'+image_list[imdx].name+'Field" value="0" />');
    //<![CDATA[
    trackbar.getObject(image_list[imdx].name).init({
      onMove : function() {
        setCaptchaValue(this.id, this.leftValue);
      },
      dual : false, // two intervals
      width : #{angl2}, // px
      roundUp: 10,
      leftLimit : 0, // unit of value
      leftValue : 0, // unit of value
      rightLimit : #{angl2}, // unit of value
      rightValue : #{angl2}, // unit of value
      clearLimits: 1,
      clearValues: 1 });
    // -->
    document.write('</div>');
    document.write('<input type="hidden" name="hashes['+imdx+']" value="'+image_list[imdx].hash+'" />');
  }


  document.write('<input type="hidden" name="time" value="#{time}" />');
  document.write('</div>');
  document.write('<div class="move_slider">#{I18n.t('not_captcha.move_sliders_or_click')}</div>');
  document.write('<div class="refresh_images" onclick="refresh_security_image()">#{I18n.t('not_captcha.reload_images')}</div>');
</script>
<noscript>
  #{
    images.map do |item|
      %$
  <div style="clear:both;padding:4px;">
    <img id="#{item[:name]}Pict" src="#{notcaptcha_url}/#{item[:hash]}?t=#{time}" align="left" />
    <select name="#{item[:name]}Field">
      <option value="">#{I18n.t('not_captcha.select')}</option>
      #{options}
    </select>
  </div>$
    end.join
  }
</noscript>
<img src="/assets/not_captcha/blank.gif" width="1" height="1" />
</div>
<!-- NotCaptcha FORM end -->
@
    end
  end
end