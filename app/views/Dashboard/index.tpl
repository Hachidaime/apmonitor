<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}

{block name='content'}
<div class="row">
  <div class="col-12">
    <div class="card rounded-0">
      <div class="card-header bg-gradient-navy rounded-0">
        <h3 class="card-title text-warning">Informasi Kegiatan</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-0">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th class="text-right align-middle" rowspan="2" width="50px">
                #
              </th>
              <th class="text-center align-middle" rowspan="2" width="*">
                Nama Kegiatan
              </th>
              <th class="text-center align-middle" rowspan="2" width="75px">
                Semua
              </th>
              <th class="text-center align-middle" colspan="3">Indikator</th>
              <th class="text-center align-middle" rowspan="2" width="75px">
                Selesai
              </th>
            </tr>
            <tr>
              <th class="bg-red" width="50px">&nbsp;</th>
              <th class="bg-yellow" width="50px">&nbsp;</th>
              <th class="bg-green" width="50px">&nbsp;</th>
            </tr>
          </thead>
          <tbody id="result_data">
            {section inner $activityInfo}
            <tr>
              <th class="text-right">{$smarty.section.inner.index+1}</th>
              <th>{$activityInfo[inner].act_name}</th>
              <th class="text-right">{$activityInfo[inner].all}</th>
              <th class="text-right">{$activityInfo[inner].red}</th>
              <th class="text-right">{$activityInfo[inner].yellow}</th>
              <th class="text-right">{$activityInfo[inner].green}</th>
              <th class="text-right">{$activityInfo[inner].finish}</th>
            </tr>
            {sectionelse}
            <tr>
              <th class="text-center" colspan="7">Data kosong ...</th>
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
<!-- prettier-ignore -->
{/block}
