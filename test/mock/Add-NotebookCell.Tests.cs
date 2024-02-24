using System.Collections.Generic;
public record SendEditableCode(string Language, string Content);
public static class Kernel
{
    public class RootMock
    {
        public SendEditableCode Sent = new SendEditableCode("", "");
        public void SendAsync(SendEditableCode command) {Sent = command;}
    }
    public static RootMock Root = new RootMock();
}
