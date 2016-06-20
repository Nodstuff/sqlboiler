{{- $tableNameSingular := .Table.Name | singular | titleCase -}}
{{- $varNameSingular := .Table.Name | singular | camelCase -}}
// One returns a single {{$varNameSingular}} record from the query.
func (q {{$varNameSingular}}Query) One() (*{{$tableNameSingular}}, error) {
  o := &{{$tableNameSingular}}{}

  boil.SetLimit(q.Query, 1)

  res := boil.ExecQueryOne(q.Query)
  err := boil.BindOne(res, boil.Select(q.Query), o)
  if err != nil {
    return nil, fmt.Errorf("{{.PkgName}}: failed to execute a one query for {{.Table.Name}}: %s", err)
  }

  return o, nil
}

// All returns all {{$tableNameSingular}} records from the query.
func (q {{$varNameSingular}}Query) All() ({{$varNameSingular}}Slice, error) {
  var o {{$varNameSingular}}Slice

  res, err := boil.ExecQueryAll(q.Query)
  if err != nil {
    return nil, fmt.Errorf("{{.PkgName}}: failed to execute an all query for {{.Table.Name}}: %s", err)
  }
  defer res.Close()

  err = boil.BindAll(res, boil.Select(q.Query), &o)
  if err != nil {
    return nil, fmt.Errorf("{{.PkgName}}: failed to assign all query results to {{$tableNameSingular}} slice: %s", err)
  }

  return o, nil
}

// Count returns the count of all {{$tableNameSingular}} records in the query.
func (q {{$varNameSingular}}Query) Count() (int64, error) {
  var count int64

  boil.SetCount(q.Query)

  err := boil.ExecQueryOne(q.Query).Scan(&count)
  if err != nil {
    return 0, fmt.Errorf("{{.PkgName}}: failed to count {{.Table.Name}} rows: %s", err)
  }

  return count, nil
}
