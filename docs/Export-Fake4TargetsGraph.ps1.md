---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Export-Fake4TargetsGraph.ps1

## SYNOPSIS
Exports a graph of a Fake4 build script's targets.

## SYNTAX

```
Export-Fake4TargetsGraph.ps1 [[-Renderer] <String>] [[-Format] <String>] [[-OutFile] <String>]
 [[-FakeVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-Fake4TargetsGraph.ps1
```

Parses build.fsx and shows the target dependency graph in build.svg.

## PARAMETERS

### -Renderer
The name of the Graphviz rendering engine to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Dot
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
The output format of the graph.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Svg
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
The filename to output the graph to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "build.$Format"
Accept pipeline input: False
Accept wildcard characters: False
```

### -FakeVersion
The specific version of Fake4 to install if it is missing.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 4.64.17
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
TODO: Parameterize build script file.
TODO: Parameterize build target, and include only it and its dependencies.
TODO: Invoke-Item?

## RELATED LINKS
