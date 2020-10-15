<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}

{block name='content'}
{*
<!-- Main row -->
<div class="row">
  <div class="col-md-6 col-12">
    <div class="card rounded-0">
      <div class="card-header bg-gradient-lightblue rounded-0">
        <h3 class="card-title">{$lastActivity.title}</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-0">
        <table class="table table-hover table-striped table-sm text-nowrap">
          <tbody>
            {section name=outer loop=$lastActivity.list}
            <tr>
              <td width="150px">
                {$lastActivity.list[outer].created_at|date_format:$smarty.const.DATETIME_FORMAT}
              </td>
              <td scope="row">{$lastActivity.list[outer].log_description}</td>
            </tr>
            {sectionelse}
            <tr>
              <td colspan="2" class="text-center">Data kosong ...</td>
            </tr>
            {/section}
          </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row (main row) -->
<!-- prettier-ignore -->
*}
{/block}
