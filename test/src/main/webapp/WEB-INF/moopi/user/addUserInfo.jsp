<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 회원가입 추가입력페이지 </title>

<! ------------------------------------------------ Bootstrap, jQuery CDN -------------------------------------------------->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
	<!-- 네이버 로그인 -->
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
		
	<!-- 다음주소 -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-------------------------------------------------------------------------------------------------------------------------->


<script>	

// # 회원가입 Event--------------------------------------------------------------------------------------------------------------------------

		// 네이버아이디 Client Id 값, RedirectURI 지정
			var naver_id_login = new naver_id_login("MJJpKOvtYqXuhtTnhQtq", "http://localhost:8080/user/loginPostNaver");

		// 네이버 사용자 프로필 조회 - naverSignInCallback function 호출
			naver_id_login.get_naver_userprofile("naverSignInCallback()"); 
			
			function naverSignInCallback() {		
				if(naver_id_login.getProfileData('id')){
					var naverId = naver_id_login.getProfileData('id').val();
					console.log("아이디 : "+naverId);	
					alert("아이디 : "+naverId);		
												
				} else {
					alert("ERROR");
					window.close();
				}//End if문
								
	 		}//End naverSignInCallback
	
	// 생년월일 관련 function-------------------------------------------------------------------
	$ (function() {
		
		// # 등록 Event--------------------------------------------------------------------------------------------------------------------------
		$( "button.btn.btn-primary" ).on("click" , function() {
			fncAddUser();
		});
	
	function Birth() {   	          
	
		    var now = new Date();
		    var year = now.getFullYear();
		    var month = (now.getMonth() + 1) > 9 ? ''+(now.getMonth() + 1) : '0'+(now.getMonth() + 1); 
		    var day = (now.getDate()) > 9 ? ''+(now.getDate()) : '0'+(now.getDate());           
		   
		    // 생년과 관련된 SelectBox
		    // [생년 : year]
			    for(var i = 1900 ; i <= year ; i++) {
			        $('#year').append('<option value="' + i + '">' + i + '</option>');        
			    }
		
		    // 생월과 관련된 SelectBox 
		    // [생월 : mm]       
			    for(var i=1; i <= 12; i++) {
			        var mm = i > 9 ? i : "0"+i ;            
			        $('#month').append('<option value="' + mm + '">' + mm + '</option>');    
			    }
		    
		    // 생일과 관련된 SelectBox
		    // [생일 : dd]
			    for(var i=1; i <= 31; i++) {
			        var dd = i > 9 ? i : "0"+i ;            
			        $('#day').append('<option value="' + dd + '">' + dd+ '</option>');    
			    }
				    
		    $("#year  > option[value="+year+"]").attr("selected", "true");        
		    $("#month  > option[value="+mm+"]").attr("selected", "true");    
		    $("#day  > option[value="+day+"]").attr("selected", "true");   
			
			// 각 변수 합치기
			//var birth = (year+'-'+mm+'-'+dd);
	  		//alert("생년월일 function에서의 birth : "+birth);
	  		//return birth;
	  		
	  		var year = year;
	  		//alert("얍얍 "+year);
	  		return year;
  		
	}
	
	var birthFunction = Birth();
	
	// # 값 담아주기 Event --------------------------------------------------------------------------------------------------------------------------		
	function fncAddUser() {
	
		alert("fncAddUser function 시작");
		
		var birth1=$("select[name='yy']").val();
		var birth2=$("select[name='mm']").val();
		var birth3=$("select[name='dd']").val();
		
		<!-- 이 부분을 .val()로 넘겨줘야하는데 변수를 넘기는 방법을 도무지 모르겠음 -->
		var birthday=(birth1+'-'+birth2+'-'+birth3);
		//alert("진짜된건가 : "+birthday);
		
		var id=$("input[name='userId']").val();
		var password=$("input[name='password']").val();
		var gender=$("select[name='gender']").val();
		var userName=$("input[name='userName']").val();		
		var phone=$("input[name='phone']").val();
		var nickname=$("input[name='nickname']").val();	
		
		var fullAddr=$("input[name='fullAddr']").val;
		var addr=$("input[name='addr']").val();
		
		var interest1=$("select[name='interestFirst']").val();
		var interest2=$("select[name='interestSecond']").val();
		var interest3=$("select[name='interestThird']").val();
		
//		//var birth1=$("input[name=birth1]").val();
//		//var birth2=$("select[name='birth2']").val();
//		//var birth3=$("input[name='birth3']").val();
		alert("반갑습니다 "+userName+"님 회원가입을 축하드립니다.");
		
		$("form").attr("method" , "POST").attr("action" , "/user/addUser").submit();	
	}
});	

// # 주소 Event--------------------------------------------------------------------------------------------------------------------------	

		$('#adrSearch').on('click', function(){		
			new daum.Postcode({	
				oncomplete: function(data) {
					$('#fullAddr').val(data.address);
					$('#addr').val(data.bname);
				}
			}).open();
		})
	
//-- 닉네임 중복체크 --------------------------------------------------------------------------------------------------------------------------

	$(function() {	
		$("#nickname").keyup(function() {
			var nickname = $('#nickname').val();		
			$.ajax({				
				url : '${pageContext.request.contextPath}/user/nicknameCheck?nickname='+nickname,
				type : 'get',
				success : function(data) {									
					if (data == 1) {							
							// 닉네임이 중복일경우							
								$("#NNCheck").text("해당 닉네임은 이미 사용중입니다.");
								$("#NNCheck").css("color", "red");
								$("#joinButton").attr("disabled", true);
						
					} else if (data == 0) {
								
								$("#NNCheck").text("사용가능한 닉네임 입니다.");
								$("#NNCheck").css("color", "black");
								$("#joinButton").attr("disabled", false);						
					
					} 
				}, error : function() {
					console.log("실패");
				}
			});
		});
	});
<!-------------------------------------------------------------------------------------------------------------------------->

// # 새 창으로 모바일번호 인증 띄우기 --------------------------------------------------------------------------------------------------------------------------
					
		
		function addUser() {
			
			var popWin;
			var addUser = $("#mobildAuth").val();
			
			popWin = window.open(
									"getMobileAuth?addUser",
									"childForm",
									"left=460, top=300, width=460, height=800, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");
			
			function setChildTest() {
				openWin.document.getElementById("cInput").value = document.getElementById("pnNum").value;				
       		}
		}
	
<!-------------------------------------------------------------------------------------------------------------------------->
	

	
	
	
</script>
<style>
body{
	padding-top: 50px;
}
</style>
</head>
<body>

<!-- Tool Bar ---------------------------------------------------------------------------------------------------------------->
	<jsp:include page="../layout/toolbar.jsp" />
<!---------------------------------------------------------------------------------------------------------------------------->

<!-- 화면구성 div Start ---------------------------------------------------------------------------------------------------------------->

<div class="container">
	
	<h1 class="bg-primary text-center">추가정보입력</h1>

<!-- FORM START ---------------------------------------------------------------------------------------------------------------->
		
	<form class="form-horizontal" name="detailForm" enctype="multipart/form-data">
		
		<!-- #기존 아이디 입력 값 / API사용의 경우 API 이메일주소 기재 될 예정 -->
		<div class="form-group">
			<label for="userId" class="col-sm-offset-1 col-sm-3 control-label">아이디</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="userId" name="userId" placeholder="여기에 이전 아이디값 가져오기" value="${user.userId}" readonly>
			</div>
		</div>
		
		<!-- 패스워드 : hidden -->
		<!--<input type="hidden" class="form-control" id="password" name="password" value="${user.password}">-->
		
		<!-- 이름 및 성별입력 -->
		<div class="form-group">
			<label for="userName" class="col-sm-offset-1 col-sm-3 control-label">이름</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="cInput" name="userName" placeholder="이름을 입력해주세요">
				</div>
				<div class="check_font" id="name_check"></div>
			<label for="gender" class="col-sm-1 control-label">성별</label>		
				<span class="col-sm-3" >
					<select name="gender">
						<option value="남성" selected="selected">남성</option>
						<option value="여성">여성</option>
					</select>
				</span>	
		</div>
		
		<!-- # 모바일번호인증 - CoolSMS API 구현해야 함 / 차후 inputtype에 readonly 기재하기-->
		<div class="form-group">
			<label for="phone" class="col-sm-offset-1 col-sm-3 control-label">모바일번호</label>
			<div class="col-sm-4">				
				<input type="text" class="form-control" id="pInput" name="phone" readonly>
				<button type="button" id="mobileAuth" class="btn btn-info" onclick="javascript:addUser()">인증하기</button>					
			</div>
		</div>
		
		<!-- # 닉네임입력 - Ajax 사용해야 함 -->
		<div class="form-group">
			<label for="nickname" class="col-sm-offset-1 col-sm-3 control-label">닉네임</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="nickname" name="nickname" placeholder="닉네임을 입력해주세요">
			</div>
			<div class="check_font" id="NNCheck"></div>
		</div>
		
		<!-- 생년월일 -->
		<div class="form-group">
			<label for="birth" class="col-sm-offset-1 col-sm-3 control-label">생년월일</label>
			<select name="yy" id="year"></select>  년
			<select name="mm" id="month"></select>  월  
			<select name="dd" id="day"></select>  일
		</div>


		<!-- #전체 거주지입력 / 주소지 API 구현해야 함 -->		
		<div class="form-group">
			<label for="ssn" class="col-sm-offset-1 col-sm-3 control-label">주소</label>
			
			<div class="col-sm-3">
				<input type="text" class="form-control" id="fullAddr" name="fullAddr" placeholder="주소지 검색을 눌러주세요" readonly>
			
			</div>
			<button type="button" class="btn btn-info" id="adrSearch" name="addr">주소지검색</button>
		</div>
		
		<div class="form-group">
			<label for="addr" class="col-sm-offset-1 col-sm-3 control-label">동</label>		
			
			<div class="col-sm-2">
				<input type="text" class="form-control" id="addr" name="addr" placeholder="차후 hidden 예정">
			</div>
			
		</div>	
		
		<!-- #패스워드 hidden 왜한건지 기억안남 -->	
		<input type="hidden" class="form-control" id="password" name="password" value="${user.password}">
		
		<!-- 관심사입력 -->
		<div class="form-group">
			<label for="interest" class="col-sm-offset-1 col-sm-3 control-label">관심사</label>
			<span class="col-sm-1">
				
				<!-- #관심사1 추가구현예정 -->
				<select name="interestFirst"> <!-- for문-->
						<option>관심사1</option>
						<option value="1">아웃도어/여행/사진/영상</option>
						<option value="2">운동/스포츠</option>
						<option value="3">인문학/책/글</option>
						<option value="4">업종/직무</option>
						<option value="5">외국/언어</option>
						<option value="6">문화/공연/축제/음악/악기</option>
						<option value="7">공예/만들기</option>
						<option value="8">댄스/무용</option>
						<option value="9">사교/인맥</option>                                    
						<option value="10">차/오토바이</option>
						<option value="11">게임/오락</option>
						<option value="12">맛집/카페</option>
				</select> 
				
				<!-- #관심사2 추가구현예정 -->
				<select name="interestSecond">
						<option>관심사2</option>
						<option value="1">아웃도어/여행/사진/영상</option>
						<option value="2">운동/스포츠</option>
						<option value="3">인문학/책/글</option>
						<option value="4">업종/직무</option>
						<option value="5">외국/언어</option>
						<option value="6">문화/공연/축제/음악/악기</option>
						<option value="7">공예/만들기</option>
						<option value="8">댄스/무용</option>
						<option value="9">사교/인맥</option>                                    
						<option value="10">차/오토바이</option>
						<option value="11">게임/오락</option>
						<option value="12">맛집/카페</option>
				</select> 
				
				<!-- #관심사3 추가구현예정 -->
				<select name="interestThird"> 
						<option>관심사3</option>
						<option value="1">아웃도어/여행/사진/영상</option>
						<option value="2">운동/스포츠</option>
						<option value="3">인문학/책/글</option>
						<option value="4">업종/직무</option>
						<option value="5">외국/언어</option>
						<option value="6">문화/공연/축제/음악/악기</option>
						<option value="7">공예/만들기</option>
						<option value="8">댄스/무용</option> 
						<option value="9">사교/인맥</option>                                    
						<option value="10">차/오토바이</option>
						<option value="11">게임/오락</option>
						<option value="12">맛집/카페</option>
				</select> 
				
			</span>
		</div>
		
<!-- 가입완료 Button ---------------------------------------------------------------------------------------------------------------->											  
		<div class="form-group">
			<div class="col-sm-offset-4  col-sm-4 text-center">
				<button type="button" id="joinButton" class="btn btn-primary">등록</button>
			</div>
		</div> 
<!---------------------------------------------------------------------------------------------------------------------------->	

<!-- FORM END ---------------------------------------------------------------------------------------------------------------->
		  			
 	</div>

</body>
</html>