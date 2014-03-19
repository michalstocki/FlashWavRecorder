package flashwavrecorder.helpers {

  import org.flexunit.asserts.assertFalse;
  import org.flexunit.asserts.assertTrue;


  public class EventHandlerValidatorTest {

    [Test]
    public function returns_false_when_handler_name_contains_non_letter_signs():void {
      // given
      var invalidHandler:String = "alert('XSS')";
      // when
      var valid:Boolean = EventHandlerValidator.validate(invalidHandler);
      // then
      assertFalse(valid);
    }

    [Test]
    public function returns_true_when_handler_name_is_plain_string():void {
      // given
      var validHandler:String = "valid_handler";
      // when
      var valid:Boolean = EventHandlerValidator.validate(validHandler);
      // then
      assertTrue(valid);
    }

  }
}
