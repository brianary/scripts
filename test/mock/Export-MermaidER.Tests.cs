using System;
using System.Collections;
using System.Collections.Generic;
public readonly record struct DataType(string TypeName)
{
    public override string ToString() => TypeName;
}
public readonly record struct Column
(
    string Name,
    DataType DataType,
    bool InPrimaryKey,
    bool IsForeignKey,
    bool Nullable,
    bool Identity,
    long IdentitySeed,
    long IdentityIncrement,
    string Default,
    ExtendedPropertyCollection ExtendedProperties
);
public class ColumnCollection: List<Column> {}
public readonly record struct MockDatabase(TableCollection Tables);
public readonly record struct Urn(string Value);
public readonly record struct Table(
    string Name,
    string Schema,
    ColumnCollection Columns,
    object ForeignKeys, // MockForeignKeyCollection would create a circular reference
    MockDatabase Parent,
    Urn Urn
);
public class TableCollection: List<Table>
{
    public Table this[string name, string schema] =>
        this.Find(table => table.Name == name && table.Schema == schema);
}
public readonly record struct ForeignKeyColumnCollection(string[] Name);
public readonly record struct MockExtendedProperty(string Name, string Value);
public class ExtendedPropertyCollection: Hashtable
{
    public ExtendedPropertyCollection(string description = "") : base(1)
    {
        base.Add("MS_Description", new MockExtendedProperty("MS_Description", description));
    }
}
public readonly record struct MockForeignKey
(
    string Name,
    string ReferencedTable,
    string ReferencedTableSchema,
    bool IsEnabled,
    Table Parent,
    ForeignKeyColumnCollection Columns,
    ExtendedPropertyCollection ExtendedProperties
);
public class MockForeignKeyCollection: List<MockForeignKey> {}
public static class MockDatabases
{
    public static ColumnCollection NullColumnCollection = new ColumnCollection();
    public static MockDatabase NullDatabase = new MockDatabase { Tables = new TableCollection() };
    public static ExtendedPropertyCollection Description(string description) =>
        new ExtendedPropertyCollection(description);
    public static Column PKeyId(string name, string datatype, long seed, long increment, string description) =>
        new Column(name, new DataType(datatype), true, false, false, true, seed, increment, null, Description(description));
    public static Column PFKey(string name, string datatype, string description) =>
        new Column(name, new DataType(datatype), true, true, false, false, 0L, 0L, null, Description(description));
    public static Column Column(string name, string datatype, bool nullable, string defaultValue, string description) =>
        new Column(name, new DataType(datatype), false, false, nullable, false, 0L, 0L, defaultValue, Description(description));
    public static ForeignKeyColumnCollection FKColumn(params string[] names) => new ForeignKeyColumnCollection { Name = names };
    public static Table Table(string name, string schema) =>
        new Table(name, schema, NullColumnCollection, null, NullDatabase, new Urn($"{schema}.{name}"));
    public static MockDatabase ParentDatabase = new MockDatabase
    {
        Tables = new TableCollection
        {
            Table("Book", "dbo"),
            Table("Author", "dbo"),
            Table("BookAuthor", "dbo"),
        }
    };
    public static MockDatabase Library = new MockDatabase
    {
        Tables = new TableCollection
        {
            new Table("Book", "dbo",
                new ColumnCollection
                {
                    PKeyId("bookid", "int", 1000000000L, 9L, "The book identity"),
                    Column("title", "varchar(30)", false, null, "The book title"),
                    Column("description", "varchar(max)", true, null, "A synopsis of the book"),
                    Column("year", "int", false, null, "Year of publication"),
                },
                null,
                ParentDatabase,
                new Urn("dbo.Book")
            ),
            new Table("Author", "dbo",
                new ColumnCollection
                {
                    PKeyId("authorid", "int", 1L, 1L, "The author identity"),
                    Column("name", "varchar(30)", false, null, "The author's name"),
                    Column("birthdate", "date", true, null, "The author's birthdate"),
                    Column("deathdate", "date", true, null, "The author's death date"),
                },
                null,
                ParentDatabase,
                new Urn("dbo.Author")
            ),
            new Table("BookAuthor", "dbo",
                new ColumnCollection
                { // name, type, pkey, fkey, nullable, identity, seed, increment, default, xprops
                    PFKey("bookid", "int", "The book identity"),
                    PFKey("authorid", "int", "The author identity"),
                },
                new MockForeignKeyCollection
                { // name, reftable, refschema, enabled, parent, columns, xprops
                    new MockForeignKey("fk_BookAuthor_Book", "Book", "dbo", true, Table("Book", "dbo"), FKColumn("bookid"), Description("References book")),
                    new MockForeignKey("fk_BookAuthor_Author", "Author", "dbo", true, Table("Author", "dbo"), FKColumn("authorid"), Description("References author")),
                },
                ParentDatabase,
                new Urn("dbo.BookAuthor")
            ),
        }
    };
}
