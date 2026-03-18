import { abilityAccessCtrl, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { calendarManager } from '@kit.CalendarKit';

const DOMAIN = 0x0000
export async function initMgr(context: common.Context) {
  const permissions: Permissions[] = ['ohos.permission.READ_CALENDAR', 'ohos.permission.WRITE_CALENDAR'];
  try {
    let atManager = abilityAccessCtrl.createAtManager();
    await atManager.requestPermissionsFromUser(context, permissions)
    return calendarManager.getCalendarManager(context);
  }catch (e) {
    return undefined
  }
}


export async function addAndUpdateEvent(calendarMgr: calendarManager.CalendarManager, startTime: number, appName:string = "ClashBox"): Promise<number> {

  console.info(`creating calendar : ${startTime} ${appName} `);
  // 指定日历账户信息
  const calendarAccount: calendarManager.CalendarAccount = {
    name: 'hap_installer',
    type: calendarManager.CalendarType.LOCAL,
    // 日历账户显示名称：建议使用应用实际名称。
    displayName: '小白调试助手'
  };
  // 日历配置信息
  const config: calendarManager.CalendarConfig = {
    enableReminder: true,
    // 设置日历账户颜色
    color: '#aabbcc'
  };
  // 日程配置信息
  const event: calendarManager.Event = {
    type: calendarManager.EventType.NORMAL,
    // 日程标题
    title: appName + `即将到期`,
    // 开始时间
    startTime: startTime,
    // 结束时间
    endTime: startTime + 60 * 60 * 1000,
    // 是否全天日程
    isAllDay:false,
    // 提醒时间
    reminderTime:[60 * 12, 60*24],
    // 备注
    description: `${appName} 的证书即将到期,请到小白调试助手里续期`,
  }
  try {
    // 创建日历账户
    const tripCalendar = await calendarMgr?.createCalendar(calendarAccount);
    if (!tripCalendar || tripCalendar === null) {
      console.error('Failed to create calendar. tripCalendar is null.');
      return 0;
    }
    // 请确保日历账户创建成功后，再进行相关日程的管理
    // 设置日历配置信息，设置日历账户颜色
    await tripCalendar.setConfig(config);

    const filterTitle = calendarManager.EventFilter.filterByTitle(appName);
    const events = await tripCalendar!.getEvents(filterTitle);
    if(events.length > 0){
      await tripCalendar.deleteEvents(events.map(d=>d.id));
    }
    // 添加日程
    const id = await tripCalendar.addEvent(event);
    event.id = id;
    console.info(`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    return id;
  } catch (error) {
    console.error(`Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    return 0;
  }
}
